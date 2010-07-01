#!/bin/dash

if [ -d /sys/class/power_supply/BAT1/ ] ; then
	PERCENT=$(echo `cut -c 1-4 /sys/class/power_supply/BAT1/charge_now`/32 | bc)
	BAT=`cat /sys/class/power_supply/BAT1/status`
	if [ "$BAT" = 'Discharging' ] ; then
		RETURN="D ${PERCENT}%"
	elif [ "$BAT" = 'Unknown' ] ; then
        	if [ "$PERCENT" -eq 100 ] ; then
                	RETURN='AC'
	        fi
	elif [ "$BAT" = 'Charging' ] ; then
		RETURN="C ${PERCENT}%"
	fi
else
	RETURN='N/A'
fi
echo $RETURN
