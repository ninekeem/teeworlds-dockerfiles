#!/bin/sh

envs_to_commands() {
    for i in "$@"
    do
        env | grep "$i" | while IFS= read -r j
        do
            OPT="$(echo "${j}" | tr '[:upper:]' '[:lower:]' | awk -F'=' '{ print $1 }')"
            VALUE="$(echo "${j}" | cut -d'=' -f2-)"
            configurator.sh "$OPT" "$VALUE"
        done
    done
}

tw_to_commands() {
    for i in "$@"
    do
        env | grep "$i" | while IFS= read -r j 
        do
            OPT="$(echo "${j}" | tr '[:upper:]' '[:lower:]' | awk -F'=' '{ print $1 }')"
        done
    done
}

permissions() {
    env | grep -e "^MOD_COMMAND" -e "^ACCESS_LEVEL" | while IFS= read -r i
    do
        TYPE="$(echo "${i}" | awk -F'=' '{ print $1 }')"
        VALUE="$(echo "${i}" | cut -d'=' -f2-)"
        OPT="$(echo "${i}" | awk -F'=' '{ print $3 }')"
        if echo "$TYPE" | grep -q "^ACCESS_LEVEL"
        then
            configurator.sh "access_level $VALUE" "$OPT"
        else
            configurator.sh "mod_command $VALUE" "$OPT"
        fi
    done
}

# If timezone set, symlink it
if [ -n "$TZ" ]
then
    echo "[init] Timezone environment variable set! Applying..."
    ln -fs "/usr/share/zoneinfo/$TZ" /etc/localtime
fi

# If there's no config directory, create it
if [ ! -e config ]
then
    mkdir -v config
fi

# If there's no config, copy default
if [ ! -e "$CONFIG_PATH" ] || [ ! -s "$CONFIG_PATH" ] || [ "$REFILL" = true ]
then
    echo "[init] No config found or REFILL=$REFILL! Copying default instead..."
    cp -v "$DEFAULT_CONFIG_PATH" "$CONFIG_PATH"
fi

envs_to_commands ^EC_ ^SV_
permissions
if [ "$VOTE_GENERATOR" = "true" ]
then
    echo "[init] VOTE_GENERATOR = $VOTE_GENERATOR, executing votegenerator.sh..."
    votegenerator.sh
else
    echo "[init] VOTE_GENERATOR = $VOTE_GENERATOR, vote generator will not be executed"
fi

# If BANLIST environment variable is true, enable banlist config
if [ "$BANLIST" = "true" ]
then
    echo "[init] Permanent banlist enabled!"
    if [ -e "$BANLIST_PATH" ] ; then
        echo "[init] Found banlist file, starting the server..."
        $EXEC_PATH -f "$BANLIST_PATH" -f "$CONFIG_PATH"
    else
        echo "[init] Banlist file not found, exiting..."
        exit 1
    fi
else
    echo "[init] Starting the server..."
    $EXEC_PATH -f "$CONFIG_PATH"
fi
