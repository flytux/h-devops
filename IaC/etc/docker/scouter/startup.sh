#!/bin/sh -x

export JAVA_OPT=${JAVA_OPT:--Xms1024m -Xmx1024m}

java $JAVA_OPT -classpath /home/scouter-server/scouter-server-boot.jar scouter.boot.Boot /home/scouter-server/lib
