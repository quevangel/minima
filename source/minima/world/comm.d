module minima.world.comm;

import minima.world.log;

import minima.message;
import minima.main : worldProcess;
import minima.generic.comm;

mixin defineCommInterface!(worldProcess);
