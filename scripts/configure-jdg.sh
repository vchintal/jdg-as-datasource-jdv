#!/bin/sh
echo ">> Force killing any running PID that bound to port 9990"
lsof -i:9990 -t | xargs kill -9

if [ -e "$JDG_HOME/standalone/configuration/jdg-ds-clustered.xml" ]; then
    rm $JDG_HOME/standalone/configuration/jdg-ds-clustered.xml
fi

echo ">> Creating a new config file jdg-ds-clustered.xml from clustered.xml"
cp  $JDG_HOME/standalone/configuration/clustered.xml \
    $JDG_HOME/standalone/configuration/jdg-ds-clustered.xml

# Start the JDG server in the background
echo ">> Starting the JDG server with config jdg-ds-clustered.xml"
nohup $JDG_HOME/bin/clustered.sh -c jdg-ds-clustered.xml > jdg.out 2>jdg.err & 

echo ">> Sleeping for 20 seconds to let the server boot up"
sleep 20

echo ">> Creating a Person Cache (distributed)"
$JDG_HOME/bin/cli.sh -c 127.0.0.1:9999 --file=add-personCache.cli
