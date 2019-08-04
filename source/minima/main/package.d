module minima.main;

import minima.intercomm.mainvideo;
import minima.intercomm.mainworld;

import video = minima.video;
import world = minima.world;

import videocomm = minima.video.comm;
import worldcomm = minima.world.comm;
import maincomm = minima.main.comm;

import std.concurrency : spawn, thisTid, Tid;
import std.variant : Algebraic, visit, Variant;

import minima.main.log : log, makeLog;

debug (main)
{
    debug = main_receive;
}

debug (main_receive)
{
    debug = main_receive_VtmQuit;
}

public
{
    shared Tid videoProcess, worldProcess, mainProcess;
}

void process()
{
    mainProcess = cast(shared Tid) thisTid;
    videoProcess = cast(shared Tid) spawn(&video.process);
    worldProcess = cast(shared Tid) spawn(&world.process);
    for (;;)
    {
        immutable message = cast(immutable) maincomm.receive;
        if (cast(immutable VideoToMain.Quit) message)
        {
            debug (main_receive_VtmQuit)
            {
                log("Received VtmQuit");
            }
            break;
        }
        else if (auto killAllMessage = cast(immutable WorldToMain.KillAll) message)
        {
            debug (main_killall)
                log("Received killall message from world.");
        }
        else
        {
            assert(false, makeLog("Unhandled message received"));
        }
    }
    worldcomm.send(new immutable MainToWorld.Quit());
    import core.time : dur;

    if (cast(WorldToMain.QuitConfirmation) maincomm.receiveTimeout(dur!"seconds"(
            1)) is null)
    {
        log("World didn't respond to quit. Terminating.");
    }
}
