#!/bin/sh

# to do: change this behavior
ENVS="$(env | grep "^EC_" | tr ' ' '_')"
for i in $ENVS ; do
    OPT=$(echo "${i}" | tr '[:upper:]' '[:lower:]' | awk -F'=' '{ print $1 }')
    VALUE=$(echo "${i}" | awk -F'=' '{ print $2 }' | tr '_' ' ')
    echo "[init][ec_filler] $OPT $VALUE"
    sed -i s/"$OPT.*"/"$OPT $VALUE"/ "$CFG"
done
