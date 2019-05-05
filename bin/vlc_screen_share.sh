 #!/bin/bash

 # Shares middle screen when docked in ESA
 # easy to figure out how to edit top-left
 # to accomodate any screen geometries

curr_proc=$(ps aux | grep vlcscreensharing | grep -v grep | awk '{print $2}')

if [ -n "$curr_proc" ]; then
   kill -9 $curr_proc
else
 cvlc \
    --no-video-deco \
    --no-embedded-video \
    --screen-fps=20 \
    --screen-top=0 \
    --screen-left=1600 \
    --screen-width=1920 \
    --screen-height=1200 \
    --video-title=vlcscreensharing \
    screen://
fi
