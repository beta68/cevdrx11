#!/bin/bash

PFAD=/storage/UBUNTU/vdr

cd /storage/UBUNTU/vdr
NEXT=ambion;

while true;
do
   case "$NEXT" in
  "ambioff")
       ./looperambi
       systemctl stop service.hyperion.ng 
       NEXT=ambion;
       ;;
   "ambion")
       ./looperx11
       systemctl stop vdr.service
       chroot /storage/UBUNTU /home/rudi/startx.sh &
       while true; do sleep 10; done
       ;;
    esac
done

