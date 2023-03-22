#!/bin/sh

CFG=autoexec_server.cfg
BANLIST_PATH=/root/.teeworlds/banlist

if [ -n "$EC_BINDADDR" ] ; then sed -i s/'ec_bindaddr.*'/"ec_bindaddr $EC_BINDADDR"/ "$CFG" ; fi
if [ -n "$EC_AUTH_TIMEOUT" ] ; then sed -i s/'ec_auth_timeout 60.*'/"ec_auth_timeout $EC_AUTH_TIMEOUT"/ "$CFG" ; fi
if [ -n "$EC_BANTIME" ] ; then sed -i s/'ec_bantime.*'/"ec_bantime $EC_BANTIME"/ "$CFG" ; fi
if [ -n "$EC_OUTPUT_LEVEL" ] ; then sed -i s/'ec_output_level.*'/"ec_output_level $EC_OUTPUT_LEVEL"/ "$CFG" ; fi
if [ -n "$EC_PASSWORD" ] ; then sed -i s/'ec_password.*'/"ec_password $EC_PASSWORD"/ "$CFG" ; fi
if [ -n "$EC_PORT" ] ; then sed -i s/'ec_port.*'/"ec_port $EC_PORT"/ "$CFG" ; fi

if [ -n "$SV_HIGH_BANDWIDTH" ] ; then sed -i s/'sv_high_bandwidth.*'/"sv_high_bandwidth $SV_HIGH_BANDWIDTH"/ "$CFG" ; fi
if [ -n "$SV_INACTIVEKICK" ] ; then sed -i s/'sv_inactivekick.*'/"sv_inactivekick $SV_INACTIVEKICK"/ "$CFG" ; fi
if [ -n "$SV_INACTIVEKICK_TIME" ] ; then sed -i s/'sv_inactivekick_time.*'/"sv_inactivekick_time $SV_INACTIVEKICK_TIME"/ "$CFG" ; fi
if [ -n "$SV_MAX_CLIENTS" ] ; then sed -i s/'sv_max_clients.*'/"sv_max_clients $SV_MAX_CLIENTS"/ "$CFG" ; fi
if [ -n "$SV_MAX_CLIENTS_PER_IP" ] ; then sed -i s/'sv_max_clients_per_ip.*'/"sv_max_clients_per_ip $SV_MAX_CLIENTS_PER_IP"/ "$CFG" ; fi
if [ -n "$SV_MOTD" ] ; then sed -i s/'sv_motd.*'/"sv_motd $SV_MOTD"/ "$CFG" ; fi
if [ -n "$SV_NAME" ] ; then sed -i s/'sv_name.*'/"sv_name $SV_NAME"/ "$CFG" ; fi
if [ -n "$SV_PORT" ] ; then sed -i s/'sv_port.*'/"sv_port $SV_PORT"/ "$CFG" ; fi
if [ -n "$SV_RCON_PASSWORD" ] ; then sed -i s/'sv_rcon_password.*'/"sv_rcon_password $SV_RCON_PASSWORD"/ "$CFG" ; fi
if [ -n "$SV_RCON_MOD_PASSWORD" ] ; then sed -i s/'sv_rcon_mod_password.*'/"sv_rcon_mod_password $SV_RCON_MOD_PASSWORD"/ "$CFG" ; fi
if [ -n "$SV_REGISTER" ] ; then sed -i s/'sv_register.*'/"sv_register $SV_REGISTER"/ "$CFG" ; fi
if [ -n "$SV_SCORELIMIT" ] ; then sed -i s/'sv_score_limit.*'/"sv_score_limit $SV_SCORELIMIT"/ "$CFG" ; fi
if [ -n "$SV_SPECTATOR_SLOTS" ] ; then sed -i s/'sv_spectator_slots.*'/"sv_spectator_slots $SV_SPECTATOR_SLOTS"/ "$CFG" ; fi
if [ -n "$SV_TOURNAMENT_MODE" ] ; then sed -i s/'sv_tournament_mode.*'/"sv_tournament_mode $SV_TOURNAMENT_MODE"/ "$CFG" ; fi

if [ "$BANLIST" = "true" ] ; then
	echo "Permanent banlist enabled!"
	if [ -e "$BANLIST_PATH" ] ; then
		echo "Found banlist file, starting the server…"
		/usr/local/bin/TrainFNG-Server -f /root/.teeworlds/banlist
	else
		echo "Banlist file not found, exiting…"
		exit 1
	fi
else
	/usr/local/bin/TrainFNG-Server
fi
