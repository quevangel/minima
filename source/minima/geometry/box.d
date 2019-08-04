module minima.geometry.box;

import std.math;

struct Box
{
    this(double[2] center, double[2] size)
    {
        this.center = center;
        this.size = size;
    }

    double[2] center, size;
    double[2] corner(string which)() const
    {
        static if (which == "lower")
            double[2] result = center[] - size[] / 2.0;
        else static if (which == "higher")
            double[2] result = center[] + size[] / 2.0;
        else
            static assert(false);
        return result;
    }

    double[2] boundary(string which)() const
    {
        static if (which == "x")
            int axis = 0;
        else static if (which == "y")
            int axis = 1;
        else
            static assert(false);

        double[2] result = [
            center[axis] - size[axis] / 2.0, center[axis] + size[axis] / 2.0
        ];
        return result;
    }

    double[2] corner(int[2] which)() const
    {
        double[2] result;
        result = center[] + which[] * size[] / 2.0;
        return result;
    }

    int[2] index(string which)()
    {
        double[2] cornerResult = corner!which;
        static if (which == "lower")
            alias snap = floor;
        else static if (which == "higher")
            alias snap = ceil;
        else
            static assert(false);
        import std.algorithm;
        import std.array;

        int[2] result = [
            cast(int) snap(cornerResult[0]), cast(int) snap(cornerResult[1])
        ];
        return result;
    }

    Box collidingBox()
    {
        auto lowerIndex = index!"lower";
        auto higherIndex = index!"higher";
        double[2] lowerIndexDouble = [
            cast(double) lowerIndex[0], cast(double) lowerIndex[1]
        ];
        double[2] higherIndexDouble = [
            cast(double) higherIndex[0], cast(double) higherIndex[1]
        ];
        double[2] size = higherIndexDouble[] - lowerIndexDouble[];
        double[2] center = lowerIndexDouble[] + size[] / 2.0;
        return Box(center, size);
    }
}
