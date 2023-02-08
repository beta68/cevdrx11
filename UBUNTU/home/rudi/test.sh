#!/bin/sh
#exit

# 4K or full HD TV?
RESOLUTION="2160p50hz"
if [ "$(cat /sys/class/display/mode | grep 2160p50hz)" = $RESOLUTION ];
then
	RESOLUTION="2160p50hz420"
	RES_FROM="1080p50hz"
	echo "4K found"
else
	RESOLUTION="1080p50hz"
	RES_FROM="1080p60hz"
	echo "Full HD only"
fi

# is FLIRC connected?
if [ "$(lsusb | grep Clay | awk '{print $(NF-1)}')" = 'Clay' ];
then
	echo "FLIRC connected"
else
	echo "No FLIRC connected!"
fi

# which system to boot?
SYSTEM=$(head -n 1 /home/rudi/BOOT | tail -n 1)

if [ "$SYSTEM" = 'VDR' ];
then echo "VDR"
elif [ "$SYSTEM" = 'KODI' ];
then echo "KODI"
elif [ "$SYSTEM" = 'X11' ];
then echo "X11"
else
	echo "No system found"
fi


if pgrep vdr >/dev/null 2>&1
then
	echo "VDR is running..."
else
	echo "VDR is not running..."
fi