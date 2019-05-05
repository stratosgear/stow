#!/usr/bin/env python

import glob
import random
import os


files = glob.glob("/mnt/data/Dropbox/Images/Wallpapers/galaxies/*.jpg")
random.shuffle(files)
# with open('/tmp/wallpapers.txt', 'w') as f:
# 	f.write(files[0] + '\n')
# 	f.write(files[1] + '\n')
# 	f.write(files[2] + '\n')
# command = "feh --no-fehbg --bg-fill \"" + files[0] + "\" \"" + files[1] + "\" \"" + files[2] + "\""
# os.system(command)

import subprocess
import json
result = subprocess.run(['swaymsg', '-t', 'get_outputs', '-r'], stdout=subprocess.PIPE)
output = result.stdout.decode('utf-8')
monitors = json.loads(output)
for i, m in enumerate(monitors):
	print (m.get("name"))
	cmd = "swaymsg output {} bg {} fill #8080A0".format(m.get("name"), files[i])
	print(cmd)
	os.system(cmd)