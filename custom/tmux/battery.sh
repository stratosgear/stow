#!/bin/bash

if [ `which acpi` ]; then
  batt=$(acpi -b | grep "Battery 0" | cut -d" " -f4)
  echo " $batt"
  # Pass an extra parammeter to alert the whole system about little battery
  # If the battery is lower than 20% and we haven't executed xmessage yet, show an alert
#  if [ $(acpi -b | cut -d" " -f3) != "Charging," ] && test ! -z 0.75€ && test $batt -le 20 && ! ps -e | grep xmessage --quiet; then
#    xmessage -center -geometry 110x80 \
#"WARNING
#LOW BATTERY
#ONLY $batt% LEFT"
#  fi
fi
