module minima.world.data;

import minima.world.terrain;

import minima.geometry.box;

package
{
    World world;
    bool mustQuit;

    class Player
    {
        this(double x, double y, double w, double h)
        {
            center[] = [x, y];
            size[] = [w, h];
        }

        alias box this;
        Box box;
        double[2] velocity;
    }

    struct World
    {
        Terrain terrain;
        Player player;
    }

    void initialization()
    {
        world.terrain = new Terrain(100, 100);
        world.player = new Player(0, 14, 2, 4);
        world.player.velocity = [2, 0];
    }
}
