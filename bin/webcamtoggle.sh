#!/bin/sh
# mpv --no-osc --no-input-default-bindings --input-conf=/dev/null --geometry=-0-0 --autofit=25% --title="mpvfloat" /dev/video2

curr_proc=$(ps aux | grep vlcwebcamfeed | grep -v grep | awk '{print $2}')

if [ -n "$curr_proc" ]; then
    kill -9 $curr_proc
else

    cvlc \
        --sub-source="marq{marquee='ESAC, Madrid - %H:%M',color=16777215,opacity=200,position=5,x=10,y=10,size=30}" \
        --no-video-deco \
        --video-title=vlcwebcamfeed \
        --width=192 \
        --height=100 \
        v4l2:///dev/video2 
fi        
