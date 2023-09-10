#!/bin/sh

add_vote() {
    configurator.sh "add_vote \"$1"\" "\"$2"\"
}

header() {
    add_vote "---$1---" "${VG_DELIMITER:-"say Do not touch me!"}"
}

custom() {
    header "$1"
    env | sort | grep "$2" | while IFS= read -r i
    do
        VALUE="$(echo "${i}" | awk -F'=' '{ print $2 }')"
        OPT="$(echo "${i}" | awk -F'=' '{ print $3 }')"
        add_vote "$VALUE" "$OPT"
    done
}

if env | grep -q "^VG_AD"
then
    custom "ADS" "^VG_AD"
fi

misc_default() {
    header MISC
    add_vote "Restart" "restart"
    add_vote "Shuffle teams" "shuffle_teams"
}

if [ "$VG_MISC_DISABLED" != 'true' ]
then
    if env | grep -q "^VG_MISC"
    then
        custom "MISC" "^VG_MISC"
    else
        misc_default
    fi
fi

scorelimits_custom() {
    for i in $1
    do
        add_vote "$i" "sv_scorelimit $i"
    done
}

scorelimits_default() {
    i=0
    while [ "$i" -le 1000 ]
    do
        add_vote "$i" "sv_scorelimit $i"
        i=$((i+100))
    done
}

if [ ! "$VG_SCORELIMITS_DISABLED" = 'true' ]
then
    header SCORELIMIT
    if [ -z "$VG_SCORELIMITS" ]
    then
        scorelimits_default
    else
        scorelimits_custom "$VG_SCORELIMITS"
    fi
fi

vg_spectator_slots() {
    if [ -z "$VS_SPECTATOR_SLOTS" ]
    then
        i=14
        while [ "$i" -ge 0 ]
        do
            VG_SPECTATOR_SLOTS="$VG_SPECTATOR_SLOTS""$i "
            i=$((i-2))
        done
    fi
    for i in $VG_SPECTATOR_SLOTS
    do
        j=$(((16 - i) / 2))
        add_vote "$j vs $j" "sv_spectator_slots $i"
    done
}

if [ ! "$VG_SPECTATOR_SLOTS_DISABLED" = 1 ]
then
    header SLOTS
    vg_spectator_slots
fi

maps() {
    find "$MAPS_DIR" -iname '*.map' | while read -r i
    do
        i="$(echo "$i" | sed -e 's&'"$MAPS_DIR"/'&&' | sed -e s/\.map//)"
        add_vote "$i" "sv_map $i"
    done
}

if [ ! "$VG_MAPS_DISABLED" = 1 ]
then
    header MAPS
    maps
fi
