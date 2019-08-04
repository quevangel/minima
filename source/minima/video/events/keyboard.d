module minima.video.events.keyboard;

import minima.core.maybe;

import derelict.sdl2.sdl : SDL_Keycode, SDLK_w, SDLK_a, SDLK_s, SDLK_d;

/++
Enumeration of handled keyboard keys.
+/
enum Key
{
    w,
    a,
    s,
    d
}

/++
Transform an SDL's SDL_Keycode into it's equivalent Key enum value.
Params:
  keyCode = SDL_Keycode to be converted to a Key.
Returns: 
  The equivalent of keyCode in Key enum value.
+/
Maybe!Key keyFromSdlKeyCode(in SDL_Keycode keyCode)
{
    switch (keyCode)
    {
    case SDLK_w:
        return cast(Maybe!Key) Key.w;
    case SDLK_a:
        return cast(Maybe!Key) Key.a;
    case SDLK_s:
        return cast(Maybe!Key) Key.s;
    case SDLK_d:
        return cast(Maybe!Key) Key.d;
    default:
        return cast(Maybe!Key) none;
    }
}
