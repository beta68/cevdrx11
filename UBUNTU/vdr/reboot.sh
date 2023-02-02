#!/bin/bash

sleep 5

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
       ./looperreboot
       reboot	
       NEXT=ambioff;
       ;;
    esac
done

