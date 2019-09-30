#!/bin/bash

# Source: https://github.com/svamberg/monitoring-plugins-glusterfs

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
MSG_OK="All pools are connected."
MSG_WARNING="Not all pools are connected."
MSG_CRITICAL="Not all pools are connected."
MSG_UNKNOWN="Gluster mischmatch"

STATE="$STATE_OK"
MSG="$MSG_OK"


LIST=`sudo gluster pool list`


FAILS=`echo "$RET" | grep -v Connected`

if [ ! -z "$FAILS" ] ; then
    MSG="$MSG_CRITICAL\n$LIST"
    STATE="$STATE_CRITICAL"
fi


echo -e "$MSG"
exit $STATE


