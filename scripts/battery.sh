#!/bin/dash

if [ -d /sys/class/power_supply/BAT1/ ] ; then
	PERCENT=$(echo `cut -c 1-4 /sys/class/power_supply/BAT1/charge_now`/32 | bc)
	BAT=`cat /sys/class/power_supply/BAT1/status`
	if [ "$BAT" = 'Discharging' ] ; then
		RETURN="Discharging ${PERCENT}%"
	elif [ "$BAT" = 'Unknown' ] ; then
		if [ "$PERCENT" -eq 100 ] ; then
			RETURN='AC'
		fi
	elif [ "$BAT" = 'Charging' ] ; then
		RETURN="Charging ${PERCENT}%"
	fi
else
	RETURN='Not present'
fi
echo $RETURN
