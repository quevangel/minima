module minima.intercomm.mainvideo;

import videocomm = minima.video.comm;
import maincomm = minima.main.comm;

interface MainToVideo : maincomm.Send, videocomm.Receive
{
    immutable static class QuitConfirmation : MainToVideo
    {
    }

    immutable static class Kill : MainToVideo
    {
        this(string reason)
        {
            this.reason = reason;
        }

        string reason;
    }
}

interface VideoToMain : videocomm.Send, maincomm.Receive
{
    immutable static class Quit : VideoToMain
    {
    }
}
