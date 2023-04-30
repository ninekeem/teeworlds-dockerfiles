#!/bin/sh

if env | grep -q "^EC_" ; then
	echo "[init] [re]filling $CFG with econ settings"
	ec_filler.sh
fi

if env | grep -q "^SV_" ; then
	echo "[init] [re]filling $CFG with server settings"
	sv_filler.sh
fi

generateVotesCfg.sh --min-players-per-team=8 --misc=false --scorelimit=false --run >> "$CFG"

if [ "$BANLIST" = "true" ] ; then
	echo "[init] Permanent banlist enabled!"
	if [ -e "$BANLIST_PATH" ] ; then
		echo "[init] Found banlist file, starting the server…"
		$EXECUTABLE -f "$BANLIST_PATH"
	else
		echo "[init] Banlist file not found, exiting…"
		exit 1
	fi
else
	echo "[init] Starting the server…"
	$EXECUTABLE
fi
