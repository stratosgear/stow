#!/bin/bash

scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 /tmp/screenshot.png

#pixel_scale='5'
#scale_down=$(( 100/pixel_scale ))
#scale_up=$(( ( 100/pixel_scale ) * pixel_scale * pixel_scale ))
#convert /tmp/screenshot.png -scale "$scale_down%" -scale "$scale_up%" /tmp/screenshot.png

# Superimpose Mr.Robot mask logo
composite -gravity center /home/stratos/stow/bin/assets/stop.png /tmp/screenshot.png  /tmp/screenshot.png

i3lock -f -i /tmp/screenshot.png && sleep 1
