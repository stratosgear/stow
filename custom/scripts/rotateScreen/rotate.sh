#!/bin/bash

# Prerequisite:
#
# Rotation of mouse movement is based on:
# http://cc.oulu.fi/~rantalai/synaptics/
# 
# Basically:
#
# sudo add-apt-repository ppa:aapo-rantalainen/ppa-aaporantalainen
# sudo apt-get update
# sudo apt-get install xserver-xorg-input-synaptics
# 
# And when you next time boot X, new driver will be in use.
#
# Usage:
# synclient Orientation=0 ; xrandr --orientation normal
# synclient Orientation=1 ; xrandr --orientation left
# synclient Orientation=2 ; xrandr --orientation inverted
# synclient Orientation=3 ; xrandr --orientation right

if  [ "$1" = "left" ]; then
	xrandr -o left && synclient Orientation=1
	exit
elif [ "$1" = "right" ]; then
	xrandr -o right && synclient Orientation=3
	exit
elif [ "$1" = "inverted" ]; then
	xrandr -o inverted && synclient Orientation=2
	exit
elif [ "$1" = "normal" ]; then
	xrandr -o normal && synclient Orientation=0
	exit
else
	echo "Usage: rotate.sh [left|right|inverted|normal]"	
fi	

