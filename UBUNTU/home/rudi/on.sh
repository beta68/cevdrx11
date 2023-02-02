#!/bin/bash

# change this for other FLIRC
device='/dev/input/event2'

# change power-on-code regarding FLIRC configuration
event_power='*code 40 (KEY_APOSTROPHE), value 1*'

evtest "$device" | while read line; do
  case $line in
    ($event_power) svdrpsend REMO on; svdrpsend PLUG softhdodroid ATTA; svdrpsend HITK OK; killall evtest; exit ;;
  esac
done