#!/bin/sh

SEP=
SEPE=

CLOCK=⌚
CALENDAR=☼
MUSIC=♫

WIDTH=${1}

SMALL=80
MEDIUM=140

if [ "$WIDTH" -gt "$MEDIUM" ]; then
  if type mpc >/dev/null; then
    #MPD="#[fg=colour252,bg=default,nobold,noitalics,nounderscore]$SEP#[fg=colour16,bg=colour252,bold,noitalics,nounderscore] $MUSIC $(mpc current)"
    date_colour='colour252'
  fi
fi

if [ "$WIDTH" -ge "$SMALL" ]; then
  UNAME="#[fg=colour252,bg=colour236,nobold,noitalics,nounderscore]$SEP#[fg=colour16,bg=colour252,bold,noitalics,nounderscore] $(uname -n)"
fi
BATTERY="#[fg=colour252,bg=colour232,nobold,noitalics,nounderscore]$SEP#[fg=colour16,bg=colour252,bold,noitalics,nounderscore] ⚡ $(~/stow/custom/tmux/battery.sh)"
DATE="#[fg=colour236,bg=colour252,nobold,noitalics,nounderscore]$SEP#[fg=colour247,bg=colour236,nobold,noitalics,nounderscore] $CALENDAR $(date +'%D')"
TIME="#[fg=colour252,bg=colour236,nobold,noitalics,nounderscore]$SEPE#[fg=colour252,bg=colour236,bold,noitalics,nounderscore] $CLOCK $(date +'%H:%M')"

echo "$BATTERY $MPD $DATE $TIME $UNAME " | sed 's/ *$/ /g'