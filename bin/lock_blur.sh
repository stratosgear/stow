#!/bin/bash

scrot /tmp/screenshot.png
convert /tmp/screenshot.png -blur 0x5 /tmp/screenshot.png
pixel_scale='5'
scale_down=$(( 100/pixel_scale ))
scale_up=$(( ( 100/pixel_scale ) * pixel_scale * pixel_scale ))
#convert /tmp/screenshot.png -scale "$scale_down%" -scale "$scale_up%" /tmp/screenshotblur.png
i3lock -f -i /tmp/screenshot.png && sleep 1
