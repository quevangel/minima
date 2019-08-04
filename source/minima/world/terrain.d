module minima.world.terrain;

import minima.world.log;
import minima.core.biarray;

debug (Terrain)
{
    debug = Terrain_this;
}
class Terrain
{
    package
    {
        this(uint widthInBlocks, uint heightInBlocks)
        {
            import std.algorithm : each;

            debug (Terrain_this)
                log("Constructing Terrain with values widthInBlocks = ",
                        widthInBlocks, ", heightInBlocks = ", heightInBlocks);

            _blocks = Biarray!BlockType(heightInBlocks, widthInBlocks, BlockType
                    .air);

            for (int x = 0; x < _blocks.columns; x++)
                for (int y = 0; y < 10; y++)
                    _blocks[y, x] = BlockType.something;
        }

        bool solidAt(int x, int y)
        {
            debug (world_Terrain_solidAt)
                log("Called Terrain.solidAt with x = ", x, ", y = ", y);
            if (!_blocks.isValidIndex(y, x))
                return false;
            return _blocks[y, x] == BlockType.something;
        }

        alias _blocks this;
    }

    package
    {
        enum BlockType
        {
            air,
            something,
        }
    }

    private
    {
        Biarray!BlockType _blocks;
    }
}
