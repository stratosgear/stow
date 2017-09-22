#!/bin/bash

xrandr \
--output eDP1 \
    --auto \
--output DP2-3 \
    --auto \
    --panning 2688x1680+2560+0 \
    --scale 1.4x1.4 \
    --right-of eDP1
	
