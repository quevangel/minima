module minima.world.physics;

import minima.world;
import data = minima.world.data;

import minima.geometry.box;

import minima.world.log;

import minima.math;

import std.math;

package
{
    void update()
    {
        immutable timeIncrement = 1.0 / 60.0;
        double[2] gravity = [0, -9];
        double[2] force = [0, 0];
        force[] += gravity[];
        if (data.world.player.onGround)
        {
            force[1] = force[1] <= 0.0? 0.0 : force[1]; // Normal force acting.
            auto velocity = data.world.player.velocity[0];
            auto direction = velocity.sgn;
            if (direction)
            {
                auto friction = - direction;
                if (velocity + timeIncrement * friction <= 0)
                {
                    data.world.player.velocity[0] = 0;
                }
                else
                {
                    force[0] += friction;
                }
            }
        }
        data.world.player.velocity[] += timeIncrement * force[];

        double[2] positionIncrement = timeIncrement * data.world.player.velocity[];
        Box newPlayerBox;
        newPlayerBox = data.world.player.box.move(positionIncrement);
        data.world.player.center = newPlayerBox.center;
    }

    bool onGround(Box box)
    {
        auto lowerY = box.corner!([0, -1])[1];
        if (lowerY.pmod(1.0) == 0)
        {
            int i = cast(int) (lowerY - 1.0);
            auto xBoundary = box.boundary!"x";
            auto xLowerIndex = cast(int) xBoundary[0].floor;
            auto xHigherIndex = cast(int) xBoundary[1].ceil;
            bool result = iota(xLowerIndex, xHigherIndex).any!(j => data.world.terrain.solidAt(j, i));
            return result;
        }
        return false;
    }

    Box move(Box box, double[2] delta)
    {
        double[2] tentativeNewPosition = box.center[] + delta[];
        // No collision, just move the player.
        if (!collides(Box(tentativeNewPosition, box.size)))
        {
            box.center = tentativeNewPosition;
            return box;
        }
        // Collision, collide in each direction.
        static foreach (axis; [0, 1])
        {
            {
                const deltaAxis = delta[axis];
                const sizeAxis = box.size[axis];
                const centerAxis = box.center[axis];
                box.center[axis] += deltaAxis;
                if (box.collides)
                {
                    box.center[axis] = centerAxis;
                    const direction = sgn(deltaAxis);
                    const X = pmod(-direction * centerAxis - sizeAxis / 2.0, 1.0);
                    box.center[axis] += direction * X;
                    bool condition;
                    condition = (box.center[axis] + direction * sizeAxis / 2.0)
                        .fmod(1.0).approxEqual(0.0);
                    assert(condition, "Center must have been aligned");
                    condition = !box.collides;
                    assert(condition, "Box must not collide");
                    while (!box.collides)
                    {
                        box.center[axis] += direction;
                    }
                    box.center[axis] -= direction;
                    import std.conv;

                    assert(!box.collides,
                            text("Box must not collide after moving in ",
                                axis, " direction."));
                }
            }
        }
        assert(!box.collides, "Box must not collide after calling move on it.");
        return box;
    }

    import std.algorithm;
    import std.array;
    import std.range;

    bool collides(Box box)
    {
        auto collidingRange = box.collidingRange;
        bool result = collidingRange.any!(
                (ref index) => data.world.terrain.solidAt(index[0], index[1]));
        return result;
    }

    auto collidingRange(Box box)
    {
        auto lowerIndex = box.index!"lower";
        auto higherIndex = box.index!"higher";
        auto result = cartesianProduct(iota(lowerIndex[0], higherIndex[0]),
                iota(lowerIndex[1], higherIndex[1])).array;
        return result;
    }
}
