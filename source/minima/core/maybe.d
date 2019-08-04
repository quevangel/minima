module minima.core.maybe;

import std.variant : Algebraic;

/++
Represents the unit type.
+/
struct None
{
}

enum none = None();

/++
Either nothing (None.Value) or a T.
+/
template Maybe(T)
{
    alias Maybe = Algebraic!(None, T);
}
