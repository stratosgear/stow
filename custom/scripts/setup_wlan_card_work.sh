#!/bin/bash

#iwlist eth1 scan		// scan for wlan

# the wlan id returned
sudo iwconfig eth1 essid vc1	

# the WEP key to connect
sudo iwconfig eth1 enc b003744fe3	

# renew the DHCP ip address
sudo dhclient eth1
