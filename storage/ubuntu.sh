#!/bin/sh
umount /storage/UBUNTU/dev/pts
umount /storage/UBUNTU/proc
umount /storage/UBUNTU/dev
umount /storage/UBUNTU/sys
umount /storage/UBUNTU/run
umount /storage/UBUNTU/ce
umount /storage/UBUNTU/storage

modprobe amlcm
modprobe videobuf-res
modprobe amlvideodri

mount -t proc none /storage/UBUNTU/proc
mount -o bind /dev /storage/UBUNTU/dev
mount -o bind /dev/pts /storage/UBUNTU/dev/pts
mount -o bind /sys /storage/UBUNTU/sys
mount -o bind / /storage/UBUNTU/ce
mount -o bind /storage /storage/UBUNTU/storage
mount -o bind /run /storage/UBUNTU/run
