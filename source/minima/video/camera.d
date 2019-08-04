module minima.video.camera;

import minima.geometry.box;

struct Camera
{
    alias box this;
    Box box;
}

struct ViewRange
{
    int lowerRow, higherRow, lowerColumn, higherColumn;
}

ViewRange getViewRange(ref Camera camera)
{
    import std.math;

    double[2] lower;
    lower[] = camera.center[] - camera.size[] / 2;
    double[2] higher;
    higher[] = camera.center[] + camera.size[] / 2;
    ViewRange viewRange;
    viewRange.lowerRow = cast(int) lower[1].floor;
    viewRange.lowerColumn = cast(int) lower[0].floor;
    viewRange.higherRow = cast(int) higher[1].floor;
    viewRange.higherColumn = cast(int) higher[0].floor;
    return viewRange;
}
