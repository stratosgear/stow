#!/usr/bin/python

# author: Stratos
# date: Fri Mar 23, 2012, 15:01:50

# Get the time when the machine booted
# Assume five minutes boot time until everything starts (very generous)
# Add the required amount of work time
# Calculate the time the working day is over

from datetime import datetime, timedelta
import os

with open('/proc/uptime', 'r') as f:
    uptime_seconds = float(f.readline().split()[0])

now = datetime.now()
started_at = now - timedelta(seconds=uptime_seconds - 5*60)
go_home_at = started_at + timedelta(hours=9, minutes=15)
late_by = ""
if (go_home_at > now):
    remaining = go_home_at - now
else: 
    remaining = now - go_home_at
    late_by = "Wow, you're late by "
print "Started at: %s" % started_at
print "Go Home at: %s" % go_home_at
print "That's  in: %s%s" % (late_by, remaining)

timesheetFile = os.path.expanduser(os.path.join("~","Dropbox.STRATOS","Dropbox", "timesheets","pph.csv"))

worked_for = now - started_at

with open(timesheetFile, "a") as myfile:
    myfile.write(started_at.strftime('%d/%m/%Y, '))
    myfile.write(started_at.strftime('%H:%M:%S, '))
    myfile.write(now.strftime(       '%H:%M:%S, '))
    myfile.write(                    '%s\n' % worked_for)
