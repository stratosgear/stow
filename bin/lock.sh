#!/bin/bash

# scrot /tmp/screenshot.png
# convert /tmp/screenshot.png -blur 0x5 /tmp/screenshotblur.png
# pixel_scale='5'
# scale_down=$(( 100/pixel_scale ))
# scale_up=$(( ( 100/pixel_scale ) * pixel_scale * pixel_scale ))
# #convert /tmp/screenshot.png -scale "$scale_down%" -scale "$scale_up%" /tmp/screenshotblur.png
# i3lock -f -i /tmp/screenshotblur.png && sleep 1


#!/bin/bash
scrot /tmp/screenshot.png
convert -noise 1x8 /tmp/screenshot.png /tmp/screenshotnoise.png
# convert +noise Laplacian /tmp/screenshotnoise.png /tmp/screenshotnoise.png
# convert -blur 0x2 /tmp/screenshotnoise.png /tmp/screenshotnoise.png
i3lock -f -i /tmp/screenshotnoise.png && sleep 1