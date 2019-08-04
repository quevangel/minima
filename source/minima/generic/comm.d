module minima.generic.comm;

mixin template defineCommInterface(alias processName)
{
    interface Send : Message
    {
    }

    interface Receive : Message
    {
    }

    void send(immutable Receive msg)
    {
        import std.concurrency;

        std.concurrency.send(cast(Tid) processName, msg);
    }

    Receive receive()
    {
        import std.concurrency;

        Receive result = null;
        std.concurrency.receive((immutable Receive msg) {
            result = cast(Receive) msg;
        }, (Variant variant) {
            assert(false, makeLog("Received unknown message of type ", variant
                .type));
        });

        return result;
    }

    Receive receiveNow()
    {
        import std.concurrency;
        import core.time;

        Receive result = null;
        std.concurrency.receiveTimeout(dur!"nsecs"(-1), (immutable Receive msg) {
            result = cast(Receive) msg;
        }, (Variant variant) {
            assert(false, makeLog("Received unknown message of type: ", variant
                .type));
        });
        return result;
    }

    import core.time : Duration;

    Receive receiveTimeout(Duration duration)
    {
        import std.concurrency;

        Receive result;
        std.concurrency.receiveTimeout(duration, (immutable Receive msg) {
            result = cast(Receive) msg;
        }, (Variant variant) {
            assert(false, makeLog("Received unknown message"));
        });
        return result;
    }
}
