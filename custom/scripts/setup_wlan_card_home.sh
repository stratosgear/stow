#!/bin/bash

#iwlist eth1 scan		// scan for wlan

# the wlan id returned
sudo iwconfig eth1 essid stratosland	

# the WEP key to connect
sudo iwconfig eth1 enc 12131415abacadae1234567890	

# renew the DHCP ip address
sudo dhclient eth1
