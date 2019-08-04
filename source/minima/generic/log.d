module minima.generic.log;

mixin template defineLogFunctions(string threadName)
{
    import std.stdio : writeln;
    import std.conv : text;

    string makeLog(T...)(T args)
    {
        return text("From thread ", threadName, ": ", args);
    }

    void log(T...)(T args)
    {
        writeln(makeLog(args));
    }
}
