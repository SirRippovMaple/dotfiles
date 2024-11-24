#!/usr/bin/env /bin/bash

if [ ! -f ~/.config/syncthing/config.xml ]; then
    bw get notes syncthing-config.sh > /tmp/syncthing-config.sh 
    chmod +x /tmp/syncthing-config.sh
    /tmp/syncthing-config.sh
    rm /tmp/syncthing-config.sh
fi
