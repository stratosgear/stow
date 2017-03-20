#!/usr/bin/env python

import glob
import random
import os


files = glob.glob("/mnt/data/Dropbox/Images/Wallpapers/galaxies/*.jpg")
random.shuffle(files)
with open('/tmp/wallpapers.txt', 'w') as f:
	f.write(files[0] + '\n')
	f.write(files[1] + '\n')
	f.write(files[2] + '\n')
command = "feh --no-fehbg --bg-fill \"" + files[0] + "\" \"" + files[1] + "\" \"" + files[2] + "\""
os.system(command)
