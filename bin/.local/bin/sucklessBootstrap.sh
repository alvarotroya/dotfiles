#!/bin/bash

SUCKLESS_DIR="repos/suckless"
MODULE="$1"
echo -e "\nBootstrapping $MODULE"
CURRENT_DIR=$(pwd)

if [[ ! -d $SUCKLESS_DIR/$MODULE ]]; then
    if [[ ! -d $SUCKLESS_DIR ]]; then
        mkdir -p $SUCKLESS_DIR && cd $_
    else 
        cd $SUCKLESS_DIR
        echo -e "\nCloning $MODULE into $(pwd)"
        git clone https://git.suckless.org/$MODULE
        cd $MODULE
    fi
else 
    # get rid of this after testing since we will always want a clean installation
    cd $SUCKLESS_DIR/$MODULE && git pull
fi

# see last comment
if [[ ! -e  "config.h" ]]; then 
    echo -e "\nCopying default config config.def.h to config.h"
    cp config.def.h config.h
fi

echo -e "\nInstalling dependencies..."
sudo apt install libxinerama-dev libxft-dev

echo -e "\nCompiling $MODULE"
if sudo make install; then
    echo -e "\nInstallation successful. Have fun using $MODULE.\n\n Make sure you are running an X-server session."
    # Check if SHELL is set
    cd $CURRENT_DIR && exec $SHELL
else
    echo -e "\nInstallation failed. Check the output above for errors."
fi
