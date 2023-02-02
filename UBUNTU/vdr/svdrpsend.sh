#!/bin/sh
export PATH='/root/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin'
chroot /storage/UBUNTU ./usr/local/bin/svdrpsend "$@"
