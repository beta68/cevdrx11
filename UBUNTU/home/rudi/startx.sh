#!/bin/bash

# restart atd (has been closed with closed runvdr)
atd

# switch resolution to finally 1080p50hz
echo 2160p50 > /sys/class/display/mode
sleep 1
echo 1080p50hz > /sys/class/display/mode
sleep 1

# bind to virtual terminal 8, start X and windows-manager
#https://gist.github.com/nspool/3d9fe1a8b369071d4cec6450d6e2a676
# important: use 16bit only, otherwise does not work
chvt 8
sleep 1
echo "/bin/sh -c 'DISPLAY=:0.0 /usr/bin/X -depth 16'" | at now
#echo "/bin/sh -c 'DISPLAY=:0.0 /usr/bin/X -depth 24'" | at now
sleep 1
#echo "/bin/sh -c 'cd /home/rudi && HOME=/home/rudi PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin DISPLAY=:0.0 /usr/bin/jwm'" | at now
echo "/bin/sh -c 'cd /home/rudi && HOME=/home/rudi PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin DISPLAY=:0.0 LANG=de_DE.UTF-8 /usr/bin/dbus-launch /usr/bin/lxsession'" | at now
sleep 1

# required after x11 start, otherwise display may turn black upon youtube 4k videos
echo 1080p60hz > /sys/class/display/mode

# pulseaudio is used by CE
killall pulseaudio
sleep 1
echo "/bin/sh -c 'HOME=/home/rudi PATH=/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/X11/bin DISPLAY=:0.0 pulseaudio --exit-idle-time=-1 -D'" | at now
