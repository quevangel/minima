module minima.world.messagehandling;

import minima.world;
import minima.world.log;

import data = minima.world.data;

import comm = minima.world.comm;
import videocomm = minima.video.comm;

import minima.intercomm.videoworld;
import minima.intercomm.mainworld;

import minima.core.biarray;

void handleMessage(comm.Receive message)
{
    if (message !is null)
    {
        if (cast(immutable MainToWorld.Quit) message)
        {
            debug (world_process_MtwQuit)
            {
                log("Received MtwQuit");
            }
            data.mustQuit = true;
        }
        else if (auto viewRequest = cast(immutable VideoToWorld.RequestView) message)
        {
            respondToViewRequest(viewRequest);
        }
        else
        {
            assert(false, makeLog("Received unhandled message."));
        }
    }
}

void respondToViewRequest(immutable VideoToWorld.RequestView viewRequest)
{
    import std.algorithm;
    import std.range;
    import minima.math.arrayindex;
    import minima.geometry.box;
    import std.conv;
    import minima.world.physics;

    auto numberOfRows = viewRequest.numberOfRows;
    auto rowRange = iota(numberOfRows);
    auto numberOfColumns = viewRequest.numberOfColumns;
    auto columnRange = iota(numberOfColumns);
    auto requestId = viewRequest.id;
    Biarray!string blockNames = Biarray!string(numberOfRows, numberOfColumns, "");
    foreach (row; rowRange)
        foreach (column; columnRange)
            blockNames[row, column] = data.world.terrain.solidAt(column, row) ? "something" : "none";
    Box[] boxes = [data.world.player.box];
    string debugMessage = text("Player on ground? ", data.world.player.onGround ? " yes" : " no");
    import std.stdio;

    writeln(debugMessage);
    debug boxes ~= data.world.player.box.collidingBox;
    auto response = new immutable WorldToVideo.ResponseView(blockNames,
            viewRequest.lowerRow, viewRequest.higherRow,
            viewRequest.lowerColumn, viewRequest.higherColumn, requestId, boxes);
    debug (world_respondToViewRequest)
        log("Sent response view");
    videocomm.send(response);
}
