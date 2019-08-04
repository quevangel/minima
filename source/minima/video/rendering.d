module minima.video.rendering;

import data = minima.video.data;
import minima.video.camera;

import derelict.sdl2.sdl : SDL_Renderer, SDL_CreateRenderer,
    SDL_DestroyRenderer, SDL_RENDERER_ACCELERATED,
    SDL_RenderClear,
    SDL_RenderPresent, SDL_SetRenderDrawColor, SDL_Rect, SDL_RenderDrawRect;

void render()
{
    SDL_SetRenderDrawColor(data.renderer, 0, 0, 0, 255);
    SDL_RenderClear(data.renderer);

    ViewRange viewRange = data.camera.getViewRange;
    auto currentView = cast(immutable) data.currentView;

    SDL_SetRenderDrawColor(data.renderer, 255, 255, 255, 255);
    for (int x = viewRange.lowerColumn; x <= viewRange.higherColumn; x++)
    {
        for (int y = viewRange.lowerRow; y <= viewRange.higherRow; y++)
        {
            double dx = cast(double) x, dy = cast(double) y;
            double[2] lowerPoint = [dx, dy + 1];
            double[2] higherPoint = [dx + 1, dy];
            int[2] lowerInCamera = lowerPoint.toWindowCoordinates;
            int[2] higherInCamera = higherPoint.toWindowCoordinates;
            int[2] size = higherInCamera[] - lowerInCamera[];
            import std.stdio;

            if (string blockName = currentView.getBlockName(x, y))
                if (blockName == "something")
                {
                    SDL_Rect rect = {
                    x:
                        lowerInCamera[0], y : lowerInCamera[1], w : size[0], h : size[1]
                    };
                    SDL_RenderDrawRect(data.renderer, &rect);
                }
        }
    }

    SDL_SetRenderDrawColor(data.renderer, 255, 0, 0, 255);
    foreach (ref box; currentView.boxes)
    {
        int[2] lowerPixel = box.corner!([-1, +1]).toWindowCoordinates;
        int[2] higherPixel = box.corner!([+1, -1]).toWindowCoordinates;
        int[2] sizeInPixels = higherPixel[] - lowerPixel[];
        assert(sizeInPixels[0] > 0 && sizeInPixels[1] > 0);
        SDL_Rect rect = {
        x:
            lowerPixel[0], y : lowerPixel[1], w : sizeInPixels[0], h : sizeInPixels[1]
        };
        SDL_RenderDrawRect(data.renderer, &rect);
    }

    SDL_RenderPresent(data.renderer);
}

int[2] toWindowCoordinates(double[2] point)
{
    double[2] topLeftCameraCorner = data.camera.corner!([-1, 1]);
    point[] -= topLeftCameraCorner[];
    int[2] windowSizeInteger = data.windowSize;
    double[2] windowSize = [
        cast(double) windowSizeInteger[0], cast(double) windowSizeInteger[1]
    ];
    double[2] windowToCameraRatio = windowSize[] / data.camera.size[];
    point[] *= windowToCameraRatio[];
    return [cast(int) point[0], -cast(int) point[1]];
}
