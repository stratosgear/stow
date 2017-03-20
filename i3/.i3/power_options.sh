#!/bin/bash

res=$(rofi -dmenu < ~/.i3/power_options)

if [ $res = "logout" ]; then
    i3-msg exit
fi
if [ $res = "restart" ]; then
    reboot
fi
if [ $res = "shutdown" ]; then
    poweroff
fi
if [ $res = "lock" ]; then
    i3lock -f -c 000000
fi
exit 0