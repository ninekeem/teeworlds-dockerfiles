#!/bin/sh

ENVS="$(env | grep "^EC_")"
echo "$ENVS" | while IFS= read -r i
do
    OPT=$(echo "${i}" | tr '[:upper:]' '[:lower:]' | awk -F'=' '{ print $1 }')
    VALUE=$(echo "${i}" | awk -F'=' '{ print $2 }' | tr '_' ' ')
    echo "[init][ec_filler] $OPT $VALUE"
    sed -i s/"$OPT.*"/"$OPT $VALUE"/ "$CFG"
done
