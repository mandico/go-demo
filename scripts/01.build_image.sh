#!/bin/bash

function print_headline() {
    HEADLINE=$1
    
    echo ""
    echo "-------------------------------------------------------------------------------------------"
    echo $HEADLINE
    echo "-------------------------------------------------------------------------------------------"
}

function print_line() {
    echo "-------------------------------------------------------------------------------------------"
}

function build_image() {
    print_headline "Build Image"
    cd $SCRIPTPATH/../code/
    docker build . -t luizmandico/$REPOSITORY:$TAG --build-arg VERSION=$TAG --no-cache
 
    if [[ $? != 0 ]];
    then
        print_headline "Failed Build Image"
        exit 1;
    fi;
    print_headline "Success Build Image"
}

REPOSITORY=$1
TAG=$2

# Absolute path to this script
SCRIPT=$(readlink -f "$0")
print_headline "Information"
echo " Script...................:" $SCRIPT
# Absolute path this script
SCRIPTPATH=$(dirname "$SCRIPT")
echo " Absolute Path............:" $SCRIPTPATH
echo " Repository...............:" $REPOSITORY
echo " Tag......................:" $TAG

build_image