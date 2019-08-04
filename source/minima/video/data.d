module minima.video.data;

import minima.video.camera;
import minima.video.events;
import comm = minima.video.comm;
import minima.video.log;

import worldcomm = minima.world.comm;

import minima.intercomm.videoworld;

import derelict.sdl2.sdl : DerelictSDL2;
import derelict.sdl2.sdl : SDL_Init, SDL_INIT_VIDEO;
import derelict.sdl2.sdl : SDL_Window, SDL_CreateWindow, SDL_DestroyWindow,
    SDL_WINDOWPOS_CENTERED, SDL_WINDOW_SHOWN, SDL_GetWindowSize;
import derelict.sdl2.sdl : SDL_Renderer, SDL_CreateRenderer,
    SDL_DestroyRenderer, SDL_RENDERER_ACCELERATED;

package
{
    WorldToVideo.ResponseView currentView;
    Camera camera;
    SDL_Window* window;
    SDL_Renderer* renderer;
    EventsInformation eventsInformation;
    bool mustQuit;
    bool killed;

    void initialize()
    {
        DerelictSDL2.load();
        SDL_Init(SDL_INIT_VIDEO);
        window = SDL_CreateWindow("minima", SDL_WINDOWPOS_CENTERED,
                SDL_WINDOWPOS_CENTERED, 800, 600, SDL_WINDOW_SHOWN);
        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);
        camera.size[] = [20, 20];
        camera.center[] = [10, 10];
        mustQuit = false;
        killed = false;
    }

    void end()
    {
        debug (video_data_end)
            log("Destroying window");
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }

    deprecated uint windowWidth()
    {
        int width, height;
        SDL_GetWindowSize(window, &width, &height);
        auto result = cast(uint) width;
        return result;
    }

    deprecated uint windowHeight()
    {
        int width, height;
        SDL_GetWindowSize(window, &width, &height);
        auto result = cast(uint) height;
        return result;
    }

    int[2] windowSize()
    {
        int width, height;
        SDL_GetWindowSize(window, &width, &height);
        int[2] result = [width, height];
        return result;
    }

    void updateView()
    {
        // Make and send request to World.
        auto request = makeViewRequest();
        worldcomm.send(request);

        // Wait for answer. 
        debug (video_data_updateView)
            log("Waiting for view");
        WorldToVideo.ResponseView mutableResponse = null;
        do
        {
            import core.time : dur;

            mutableResponse = cast(WorldToVideo.ResponseView) comm
                .receiveTimeout(dur!"nsecs"(1_000_000_000));
            if (mutableResponse is null)
            {
                debug (video_data_updateView)
                    log("Couldn't update view: World not responding");
                return;
            }
            debug (video_data_updateView)
                log("Got message");
        }
        while (mutableResponse is null);
        debug (video_data_updateView)
            log("Got view");

        auto response = cast(immutable) mutableResponse;
        // response verification. 
        assert(response.respondsTo(request));
        // update current view.
        currentView = mutableResponse;
        debug (video_updateView)
            log("Received response view");
    }

    void logCurrentView()
    {
        import std.stdio;

        foreach (i; currentView.lowerRow .. currentView.higherRow - 1)
        {
            foreach (j; currentView.lowerColumn .. currentView.higherColumn - 1)
            {
                write(currentView.blockNames[i, j], " ");
            }
            writeln;
        }
    }

    immutable(VideoToWorld.RequestView) makeViewRequest()
    {
        ViewRange viewRange = camera.getViewRange();
        debug (video_makeViewRequest)
        {
            log(viewRange);
        }
        return new immutable VideoToWorld.RequestView(viewRange.lowerRow,
                viewRange.higherRow, viewRange.lowerColumn, viewRange
                .higherColumn);
    }
}
