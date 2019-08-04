module minima.video.events;

import minima.video.events.keyboard;

import data = minima.video.data;

import maincomm = minima.main.comm;

import minima.intercomm.mainvideo;

import std.variant : visit;
import std.stdio : writeln;

// SDL2 Events 
import derelict.sdl2.sdl : SDL_Event, SDL_PollEvent, SDL_QUIT, SDL_KEYDOWN, SDL_KEYUP;

void handleSdlEvents()
{
    SDL_Event event;
    while (SDL_PollEvent(&event))
    {
        data.eventsInformation.dispatch(event);
    }
    if (data.eventsInformation.userRequestedQuit)
    {
        debug (video_process_userQuit)
            writeln("User requested quit.");
        maincomm.send(new immutable VideoToMain.Quit());
        data.mustQuit = true;
    }
}

/++
Struct representing the relevant information extracted from sdl's events.
+/
struct EventsInformation
{
    public
    {
        /++
Extract relevant information about an event into the structure.
+/
        void dispatch(const SDL_Event event)
        {
            switch (event.type)
            {
            case SDL_QUIT:
                m_userRequestedQuit = true;
                break;
            case SDL_KEYDOWN:
                keyFromSdlKeyCode(event.key.keysym.sym).visit!((Key key) {
                    this.m_isKeyDown[key] = true;
                    debug (input)
                        writeln("Pressed ", key, ".");
                }, (None) {
                    debug (input)
                        writeln("Unrecognized key pressed.");
                });
                break;
            case SDL_KEYUP:
                keyFromSdlKeyCode(event.key.keysym.sym).visit!((Key key) {
                    this.m_isKeyDown[key] = false;
                    debug (input)
                        writeln("Released ", key, ".");
                }, (None) {
                    debug (input)
                        writeln("Unrecognized key released.");
                });
                break;
            default:
                break;
            }
        }

        /++
Tells if the given key is currently pressed.
+/
        bool keyIsDown(Key key) const
        {
            if (const(bool)* value = key in m_isKeyDown)
            {
                return *value;
            }
            return false;
        }
        /++
Tells whether the user requested the application to quit.
+/
        bool userRequestedQuit() const
        {
            return m_userRequestedQuit;
        }
    }

    private
    {
        bool[Key] m_isKeyDown;
        bool m_userRequestedQuit;
    }
}
