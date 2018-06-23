#!/bin/bash

dest=/home/stratos/stabilized
mkdir -p $dest

inputfname=$(basename $1)
transf=$dest/$inputfname.trf

destfile=$dest/$inputfname

#echo $inputfname
#echo $transf
#echo $destfile

ffmpeg -i $1 -vf vidstabdetect=shakiness=6:stepsize=6:mincontrast=0.1:result=$transf -f null -

# Interpolation with bicubic gives white pixels in the pixels of very low contrast 
# leading to artifacts that look like thin white noise in these areas.
# Bilinear does not exhibit these artifacts
# http://www.ffmpeg-archive.org/libvistab-bicubic-interpolation-low-exposure-artefacts-td4681398.html
ffmpeg -i $1 -filter:a loudnorm -vf vidstabtransform=smoothing=30:interpol=bilinear:input=$transf,unsharp,fade=t=in:st=0:d=1 -c:v libx264 -tune film -preset slow -crf 23 -x264opts fast_pskip=0 $destfile


#adjust brightnes
#ffplay -vf eq=brightness=0.06:saturation=2 INPUT.MOV
# eq=brightness=-0.15:gamma=0.4:gamma_weight=0.15:saturation=1.1
# -vf eq=brightness=-0.15:saturation=1.1

# Audio
# https://trac.ffmpeg.org/wiki/AudioVolume
#ffmpeg -i  -filter:a loudnorm output.wav