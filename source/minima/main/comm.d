module minima.main.comm;

import minima.message : Message;
import minima.generic.comm : defineCommInterface;
import minima.main : mainProcess;
import minima.main.log;

mixin defineCommInterface!(mainProcess);
