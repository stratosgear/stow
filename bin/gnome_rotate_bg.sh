#!/bin/bash
 
walls_dir=/home/me/Dropbox/Images/Wallpapers/Tablet.Note.2014
selection=$(find $walls_dir -type f -name "*.jpg" -o -name "*.png" | shuf -n1)
gsettings set org.gnome.desktop.background picture-uri "file://$selection"
