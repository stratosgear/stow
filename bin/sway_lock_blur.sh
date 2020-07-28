#!/bin/bash

# grim /tmp/screenshot.png
# convert /tmp/screenshot.png -blur 0x5 /tmp/screenshot.png

# #pixel_scale='5'
# #scale_down=$(( 100/pixel_scale ))
# #scale_up=$(( ( 100/pixel_scale ) * pixel_scale * pixel_scale ))
# #convert /tmp/screenshot.png -scale "$scale_down%" -scale "$scale_up%" /tmp/screenshot.png

# # Superimpose Mr.Robot mask logo
# composite -gravity center /home/stratos/stow/bin/assets/stop.png /tmp/screenshot.png  /tmp/screenshot.png

# swaylock -f -i /tmp/screenshot.png && sleep 1

#!/bin/bash
 
# Dependencies:
# imagemagick
# swaylock
# grim
 
IMAGE=/tmp/i3lock.png
LOCK=~/stow/bin/assets/stop.png
LOCKARGS=""
 
# All options are here: http://www.imagemagick.org/Usage/blur/#blur_args
#BLURTYPE="0x5" # 7.52s
BLURTYPE="0x2" # 4.39s
#BLURTYPE="5x3" # 3.80s
#BLURTYPE="2x8" # 2.90s
#BLURTYPE="2x3" # 2.92s

for OUTPUT in `swaymsg -t get_outputs | jq -r '.[] | select(.active == true) | .name'`
do
    IMAGE=/tmp/$OUTPUT-lock.png
    grim -o $OUTPUT $IMAGE
    #convert $IMAGE -blur $BLURTYPE -font Liberation-Sans -pointsize 26 -fill white -gravity center -comment 'Type password to unlock' - | composite -gravity center $LOCK - $IMAGE
    corrupter -mag 1 -boffset 1  -meanabber 20 $IMAGE $IMAGE
    composite -gravity center $LOCK $IMAGE $IMAGE
    LOCKARGS="${LOCKARGS} --image ${OUTPUT}:${IMAGE}"
    IMAGES="${IMAGES} ${IMAGE}"
done
# swaylock --text-color=ffffff00 --inside-color=ffffff1c --ring-color=ffffff3e --line-color=ffffff00 --key-hl-color=00000080 --ring-ver-color=00000000 --inside-ver-color=0000001c --ring-wrong-color=00000055 --inside-wrong-color=0000001c  $LOCKARGS
swaylock $LOCKARGS
rm $IMAGES