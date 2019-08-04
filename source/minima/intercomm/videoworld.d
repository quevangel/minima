module minima.intercomm.videoworld;

import minima.message;
import videocomm = minima.video.comm;
import worldcomm = minima.world.comm;

import minima.geometry.box;

import minima.core.biarray;

/++
Video to World messages.
+/
interface VideoToWorld : videocomm.Send, worldcomm.Receive
{
    static immutable class RequestView : VideoToWorld
    {
        public
        {
            static int idCounter = 0;
            this(int lowerRow, int higherRow, int lowerColumn, int higherColumn)
            {
                this.lowerRow = lowerRow;
                this.higherRow = higherRow;
                this.lowerColumn = lowerColumn;
                this.higherColumn = higherColumn;
                this.id = RequestView.idCounter++;
            }

            int lowerRow, higherRow, lowerColumn, higherColumn, id;

            int numberOfRows()
            {
                return higherRow - lowerRow + 1;
            }

            int numberOfColumns()
            {
                return higherColumn - lowerColumn + 1;
            }
        }
    }
}

/++
World to video messages.
+/
interface WorldToVideo : worldcomm.Send, videocomm.Receive
{
    static immutable class ResponseView : WorldToVideo
    {
        public
        {
            this(Biarray!string blockNames, int lowerRow, int higherRow,
                    int lowerColumn, int higherColumn,
                    int requestId, Box[] boxes, string debugMessage = "")
            in
            {
                assert(higherRow - lowerRow + 1 == blockNames.rows);
                assert(higherColumn - lowerColumn + 1 == blockNames.columns);
            }
            do
            {
                this.blockNames = cast(immutable) blockNames;
                this.numberOfRows = cast(uint) blockNames.rows;
                this.numberOfColumns = cast(uint) blockNames.columns;
                this.debugMessage = debugMessage;
                this.boxes = boxes.idup;
                this.lowerRow = lowerRow;
                this.lowerColumn = lowerColumn;
                this.higherRow = higherRow;
                this.higherColumn = higherColumn;
                this.requestId = requestId;
            }

            string getBlockName(int x, int y)
            {
                if (blockNames.isValidIndex(y, x))
                    return blockNames[y, x];
                return null;
            }

            bool respondsTo(immutable VideoToWorld.RequestView request)
            {
                return request.id == requestId;
            }

            Biarray!string blockNames;
            Box[] boxes;
            int lowerRow, higherRow, lowerColumn, higherColumn, requestId;
            uint numberOfRows, numberOfColumns;
            string debugMessage;
        }
    }
}
