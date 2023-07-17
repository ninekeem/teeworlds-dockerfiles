#!/bin/sh

MOD_COMMANDS="$(env | grep "MOD_COMMAND")"
for i in $MOD_COMMANDS ; do
	MOD_COMMAND=$(echo "${i}" | awk -F'=' '{ print $2 }')
	echo "[init][mod_command] mod_command $MOD_COMMAND 1"
	echo "mod_command $MOD_COMMAND 1" >> "$CFG"
done
