#!/bin/bash
#
# Write by Karfield
#
# Free to use it!)
#
BING=http://www.bing.com
TMPFILE=/tmp/bing.html
WALLPAPER=/home/$USER/Downloads/bing.jpg
echo “Try to get the BING page…”
wget -q $BING -O $TMPFILE
! [ -e $TMPFILE ] && exit;
URL=$BING$(sed -n “s/\(.*\)g_img={url\:’\([0-9a-Z?=%_-\\/\\.]*\)’\,id\(.*\)/\2/p” < $TMPFILE)
echo "Get the picture's URL = "$URL
rm $TMPFILE
mv $WALLPAPER{,-old}
echo "Download the wallpaper… "
wget -q $URL -O $WALLPAPER
if [ -e $WALLPAPER ]; then
echo "We got it, set the background…"
gsettings set org.gnome.desktop.background picture-uri file:///$WALLPAPPER
#gconftool-2 –type string –set /desktop/gnome/background/picture_filename $WALLPAPER
#gconftool-2 –type string –set /desktop/gnome/background/picture_options zoom
#gconftool-2 –type string –set /desktop/gnome/background/primary_color black
fi
