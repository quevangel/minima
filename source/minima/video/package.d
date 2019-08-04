module minima.video;

import data = minima.video.data;

import rendering = minima.video.rendering;

import comm = minima.video.comm;

import minima.intercomm.mainvideo;

import events = minima.video.events;

import minima.generic.timing;

debug import minima.video.log;

debug import std.stdio;

debug (video_process)
{
    debug = video_process_MtvQuit;
    debug = video_process_userQuit;
}
public void process()
{
    import std.datetime.stopwatch : StopWatch, AutoStart;
    import core.thread : Thread;
    import core.time : Duration, dur;

    auto stopWatch = StopWatch(AutoStart.no);
    immutable fps = 60L;
    immutable frameTime = 1_000_000_000L / fps;
    data.initialize;
    for (;;)
    {
        doOnTime!frameProcess(stopWatch, frameTime);
        if (data.mustQuit)
            break;
    }
    data.end;
}

void frameProcess()
{
    data.updateView;
    rendering.render;
    events.handleSdlEvents;
}
