#!/bin/sh

BANLIST_PATH=/root/.teeworlds/banlist
CFG=autoexec.cfg
EXECUTABLE=/teeworlds-godfng/fng2_srv

ENVS="$(env | grep '^EC_\|^SV_')"
for i in $ENVS ; do
    OPT=$(echo "${i}" | tr '[:upper:]' '[:lower:]' | awk -F'=' '{ print $1 }')
    VALUE=$(echo "${i}" | awk -F'=' '{ print $2 }')
    sed -i s/"$OPT.*"/"$OPT $VALUE"/ "$CFG"
done

for i in $(echo "$MOD_COMMAND" | sed -e s/','/' '/g) ; do
	echo "mod_command $i 1" >> $CFG
done

if [ "${BANLIST}" = "true" ] ; then
	echo "Permanent banlist enabled!"
	if [ -e "$BANLIST_PATH" ] ; then
		echo "Found banlist file, starting the server…"
		$EXECUTABLE -f $BANLIST_PATH
	else
		echo "Banlist file not found, exiting…"
		exit 1
	fi
else
	$EXECUTABLE
fi
