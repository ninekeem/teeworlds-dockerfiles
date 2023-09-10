#!/bin/sh

if grep -q "$1" "$CONFIG_PATH"
then
    if grep -q "$1 $2" "$CONFIG_PATH"
    then
        echo "[init][configurator] '$1 $2' is already in the config. Skipping..."
    else
        echo "[init][configurator] '$1 $2' is not the same as in the config. Rewriting..."
        sed -i 's&'"$1"'.*&'"$1 $2"'&' "$CONFIG_PATH"
    fi
else
    echo "[init][configurator] '$1 $2' is not in the config. Appending..."
    echo "$1 $2" >> "$CONFIG_PATH"
fi
