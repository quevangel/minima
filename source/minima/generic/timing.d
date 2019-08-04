module minima.generic.timing;

import std.datetime.stopwatch : StopWatch;

bool doOnTime(alias F)(StopWatch stopWatch, long nsecs)
{
    import core.thread;
    import core.time;

    stopWatch.reset();
    stopWatch.start();
    F();
    stopWatch.stop;
    long elapsed = stopWatch.peek.total!"nsecs";
    long remaining = nsecs - elapsed;
    if (remaining > 0)
    {
        Thread.getThis.sleep(dur!"nsecs"(remaining));
        return true;
    }
    else
    {
        return false;
    }
}
