#!/bin/sh

if [ -z "$JDG_HOME" ]; then
    echo "The variable JDG_HOME is not set. Exiting..."
    echo
    exit
fi
if [ -z "$JDV_HOME" ]; then
    echo "The variable JDV_HOME is not set. Exiting..."
    echo
    exit
fi

pushd scripts
./configure-jdg.sh
./configure-jdv.sh
popd

