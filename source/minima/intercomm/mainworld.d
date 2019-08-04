module minima.intercomm.mainworld;

import minima.message;

import maincomm = minima.main.comm;
import worldcomm = minima.world.comm;

interface WorldToMain : worldcomm.Send, maincomm.Receive
{
    static class QuitConfirmation : WorldToMain
    {
    }

    immutable static class KillAll : WorldToMain
    {
        this(string reason)
        {
            this.reason = reason;
        }

        string reason;
    }
}

interface MainToWorld : maincomm.Send, worldcomm.Receive
{
    static class Quit : MainToWorld
    {
    }
}
