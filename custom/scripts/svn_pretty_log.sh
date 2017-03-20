#!/usr/bin/python

# show svn log as a summary with revision, username and comment on one line
# with no extra lines
from getopt import getopt
from subprocess import Popen, PIPE
from sys import argv

# pass selected options straight through to svn log
opts, args = getopt(argv[1:],"l:", ["limit"]) 

# Add path if given, otherwise default to top/src
path = (args[0] if len(args) > 0 else "top/src")

# Start bulding the command line
cmd = ["svn", "log"] + [(opt + " " + arg) for opt, arg in opts] + [path]
print cmd

svnlog = Popen(cmd, stdout=PIPE)
lines = svnlog.splitlines()

# Parse the output and reformat
sep = "-" * 72
for i, line in enumerate(lines):
  if line == sep and i+3 <= len(lines):
    info, comment = lines[i+1], lines[i+3]
    bar1 = info.find("|")
    bar2 = info.find("|", bar1+1)
    print info[:bar2+2] + comment
