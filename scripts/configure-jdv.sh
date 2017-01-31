#!/bin/sh 
export OLD_CONFIG=$JDV_HOME/standalone/configuration/standalone.xml
export NEW_CONFIG=$JDV_HOME/standalone/configuration/jdg-ds-standalone.xml
export JDG_VERSION=6.6.1
export JDG_MODULES_NAME=jboss-datagrid-${JDG_VERSION}-eap-modules-remote-java-client
export JDG_MODULES_ZIP=${JDG_MODULES_NAME}.zip
export JDG_MODULES_ZIP_PATH=../binaries/$JDG_MODULES_ZIP

echo ">> Force killing any running PID that bound to port 10090"
lsof -i:10090 -t | xargs kill -9

if [ -e "$NEW_CONFIG" ]; then
    rm $NEW_CONFIG
fi

if [ -e $JDG_MODULES_ZIP_PATH ]; then 
    echo ">> JDG Remote Java Client Module found. Unzipping it $JDV_HOME/modules folder"
    unzip $JDG_MODULES_ZIP_PATH -d /tmp
    cp -R /tmp/$JDG_MODULES_NAME/* $JDV_HOME
    rm -rf /tmp/$JDG_MODULES_NAME
else
    echo "No JDG Remote Java Client Module found. Skipping ..."
fi

echo ">> Creating a new profile jdg-ds-standalone.xml from standalone.xml"
cp  $JDV_HOME/standalone/configuration/standalone.xml \
    $JDV_HOME/standalone/configuration/jdg-ds-standalone.xml

pushd $(pwd)/..
mvn clean package

echo ">> Deploying the Person Pojo module into modules directory of $JDV_HOME"
unzip -o target/person-pojo-jboss-as7-dist.zip -d $JDV_HOME/modules/system/layers/base

popd 

echo ">> Starting the JDV server with profile jdg-ds-standalone.xml"
nohup $JDV_HOME/bin/standalone.sh -c jdg-ds-standalone.xml -Djboss.socket.binding.port-offset=100 > jdv.out 2>jdv.err &

echo ">> Sleeping for 20 seconds before adding the Infinispan datasource Resource Adapter"
sleep 20

$JDV_HOME/bin/jboss-cli.sh -c --controller=127.0.0.1:10099 --file=add-infinispan-ra.cli

echo ">> Deploying the people-vdb.xml in deployments folder"
pushd $(pwd)/..
cp vdb/people-vdb.xml $JDV_HOME/standalone/deployments
popd

