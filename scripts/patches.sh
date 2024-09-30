#!/bin/sh
# I know that's not the best way to patch, but c'mon...

if [ -n "$ECON_CLIENTS" ]
then
	if [ "$ECON_CLIENTS" -ge 0 ]
	then
		echo "ECON_CLIENTS = $ECON_CLIENTS! Patching..."
		sed -i \
			"s@NET_MAX_CONSOLE_CLIENTS = 4@NET_MAX_CONSOLE_CLIENTS = $ECON_CLIENTS@" \
				/tw/sources/src/engine/shared/network.h
	else
		echo "ECON_CLIENTS = $ECON_CLIENTS, which is NOT the number"
	fi
else
	echo "ECON_CLIENTS is empty! Skipping..."
fi
