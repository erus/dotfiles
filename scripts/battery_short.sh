#!/bin/dash

BAT=BAT1

if [ -d /sys/class/power_supply/${BAT}/ ] ; then
	PERCENT=$(echo `cat /sys/class/power_supply/${BAT}/charge_now`/`cat /sys/class/power_supply/${BAT}/charge_full | sed 's/00$//'` | bc)
	BAT=`cat /sys/class/power_supply/${BAT}/status`
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
