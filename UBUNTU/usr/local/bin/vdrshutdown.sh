#!/bin/bash

# raxda zero does not have a RTC
# comment this in for Odroid N2(+)

#sudo hwclock --systohc --utc
#NextTimer=$(($1 - 600 ))  # 10 minutes earlier
#
#sudo bash -c "echo 0 > /sys/class/rtc/rtc0/wakealarm"
#sudo bash -c "echo $NextTimer > /sys/class/rtc/rtc0/wakealarm"

#switch targa display off
#svdrpsend PLUG targavfd OFF

# usual way but not for ARM
#sudo /sbin/poweroff
##sudo halt -p
#WOL:
#sudo systemctl suspend

# CoreElec: kill loopershutdown to shut down from host
# not required for Radxa zero but for Odroid
#killall loopershutdown

# Radxa Zero
# dettach output device. this will still allow vdr to record
svdrpsend REMO off
svdrpsend PLUG softhdodroid DETA
# allow to switch it on again using remot control
at -f /home/rudi/on.sh now