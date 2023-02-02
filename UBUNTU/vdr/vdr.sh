#!/bin/sh

# mount devpts for ssh
mount devpts /dev/pts -t devpts

#killall splash-image
#systemctl stop service.hyperion.ng.service 
#exit

do_mount() {
mount -t proc none /storage/UBUNTU/proc
mount -o bind /dev /storage/UBUNTU/dev
mount -o bind /dev/pts /storage/UBUNTU/dev/pts
mount -o bind /sys /storage/UBUNTU/sys
mount -o bind / /storage/UBUNTU/ce
mount -o bind /storage /storage/UBUNTU/storage
mount -o bind /run /storage/UBUNTU/run
}

sleep 3 
killall splash-image
#modprobe amlcm
#modprobe videobuf-res
#modprobe amlvideodri

#switch off ambilight by default to save power
systemctl stop service.hyperion.ng

# required for odroid
# required for radxa zero?
systemctl unmask kodi
systemctl start kodi
systemctl mask kodi
sleep 3 
# need to send 1 second of video. otherwise amazon VOD will show artefacts
kodi-send --action="PlayMedia(/storage/UBUNTU/vdr/do_not_delete.ts)"
sleep 1
kodi-send --action=Stop
systemctl stop kodi
#/usr/lib/coreelec/smp-affinity.sh

[ ! -d "/storage/UBUNTU/dev/usb" ] && do_mount

export PATH='/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin'
chroot /storage/UBUNTU /home/rudi/runvdr & 
