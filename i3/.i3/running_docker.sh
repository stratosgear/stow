#!/bin/bash

running=`docker ps -f status=running | wc -l | awk '{print $1-1}'`
stopped=`docker ps -f status=exited | wc -l | awk '{print $1-1}'`

echo $running:$stopped

# When running for i3pystatus bar
# Exiting with 1 is alerting 
#[[ $running -gt 0 ]] && exit 1
#exit 0 
