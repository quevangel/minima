module minima.world;

import minima.world.terrain;
import minima.intercomm.mainworld;
import minima.intercomm.videoworld;
import minima.world.log;
import videocomm = minima.video.comm;
import maincomm = minima.main.comm;
import comm = minima.world.comm;
import phys = minima.world.physics;
import minima.generic.timing;
import data = minima.world.data;

import std.variant : Variant;

debug import minima.world.log;

debug (world)
{
    debug = world_process;
}

public
{
    debug (world_process)
    {
        debug = world_process_MtwQuit;
        debug = world_process_mainLoop;
    }
    void process()
    {
        import minima.world.messagehandling : handleMessage;
        import std.datetime.stopwatch : StopWatch;

        StopWatch stopWatch;
        StopWatch fpsCounter;
        import std.stdio;

        data.initialization;
        for (;;)
        {
            try
            {
                fpsCounter.reset;
                fpsCounter.start;
                doOnTime!(phys.update)(stopWatch, 1_000_000_000L / 60);
                handleMessage(comm.receiveNow());
                if (data.mustQuit)
                {
                    maincomm.send(new immutable WorldToMain.QuitConfirmation);
                    return;
                }
                fpsCounter.stop;
            }
            catch (Error error)
            {
                string errorString = makeLog("Error captured in main loop: ",
                        error.msg, " <=> ", error.info);
                log(errorString);
                maincomm.send(new immutable WorldToMain.KillAll(errorString));
                return;
            }
        }
    }
}
