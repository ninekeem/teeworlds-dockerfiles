#!/bin/sh

if [ ! -f '/config/fng.cfg' ]; then
    echo 'Not found config, copying default'
    cp /usr/local/share/fng/defaultconfig /config/fng.cfg
fi

while true;
do
    fng2_srv -f /config/fng.cfg
    sleep 3
done