module minima.math.modular;

import std.math;

T pmod(T)(T x, T y)
in
{
}
out (result)
{
    assert(0 <= result && result < y);
}
do
{
    auto result = fmod(x, y);
    if (result < 0)
        return result + y;
    else
        return result;
}
