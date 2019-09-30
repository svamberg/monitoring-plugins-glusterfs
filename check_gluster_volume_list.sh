#!/bin/bash

# Source: https://github.com/svamberg/monitoring-plugins-glusterfs

STATE_OK=0
STATE_WARNING=1
STATE_CRITICAL=2
STATE_UNKNOWN=3
MSG_OK="All volumes are online."
MSG_WARNING="Not all volumes are online."
MSG_CRITICAL="Not all volumes are online."
MSG_UNKNOWN="Gluster mischmatch"

STATE=$STATE_OK
MSG="";

VOLUMES=`sudo gluster volume list`

for VOLUME in $VOLUMES; do
    STATUS=`sudo gluster volume status $VOLUME detail`
    FAILS=`echo "$STATUS" | grep -P '^(Brick|Online).*' | cut -d':' -f2-  | sed '$!N;s/\n/ /' | grep -P -v '.*Y\s*$'`
    if [ ! -z "$FAILS" ] ; then
        MSG="$FAILS\n$MSG"
        STATE=$STATE_CRITICAL
    fi
done

case $STATE in 
    0)
        MSG="$MSG_OK"
        ;;
    1)
        MSG="$MSG_WARNING\n$MSG"
        ;;

    2)  
        MSG="$MSG_CRITICAL\n$MSG"
        ;;
    3)
        MSG="$MSG_UNKNOWN\n$MSG"
        ;;
esac

echo -e "$MSG"
exit $STATE


