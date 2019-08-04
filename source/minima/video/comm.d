module minima.video.comm;

import minima.message;
import minima.main : videoProcess;
import minima.video.log;
import minima.generic.comm;

mixin defineCommInterface!(videoProcess);
