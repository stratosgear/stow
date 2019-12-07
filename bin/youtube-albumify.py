#!/usr/bin/python

import re
import sys
from shutil import which
import shlex
import subprocess
from subprocess import Popen, PIPE
import os

# https://regex101.com/r/yxIeVd/4
regex = re.compile("^(?P<id>\d+.?)?\s*(?P<title>.*?)(\((?P<artist>.*)\))?\s*(?P<hrs>\d?\d:)?(?P<mins>\d?\d):(?P<secs>\d\d)\s*$")


def is_tool(name):
    """Check whether `name` is on PATH and marked as executable."""

    if not which(name):
        print(f"You will need to have the [{name}] executable on your path. Exiting...")
        sys.exit(-1)

def get_valid_filename(s):
    """ Get a valid filename from a string"""
    s = str(s).strip().replace(' ', '_')
    return re.sub(r'(?u)[^-\w.]', '', s)

def extract_track_info(s):
    """ Tries to parse a string line and extract track name, artist if exists
    and start time.
    Sample lines that can currently be handled are demonstrated at regex101 at:
    https://regex101.com/r/yxIeVd/4
    Basically looks like:
    "7. River tale (Silent Island) 22:01\n"

    """
    if not line:
        return

    match = regex.match(s)
    groups = match.groupdict()

    if groups.get('hrs'):
        start = f"{groups.get('hrs')}"
    else: 
        start = f"00:"

    start = f"{start}{groups.get('mins')}:{groups.get('secs')}"
    groups['start'] = start
    
    # remove period from track id
    if groups.get('id'):
        groups['id'] = groups['id'][0:-1]

    # remove open/close parenthesis
    if groups.get('artist'):
        groups['artist'] = groups['artist'].replace("(", "")
        groups['artist'] = groups['artist'].replace(")", "").strip()
    else:
        groups['artist'] = artist

    groups['title'] = groups['title'].strip()
    
    return groups

def print_tracks(tracks):
    """ Print the list of tracks so the user can validate if parsing was correct """

    for i in range(len(tracks)):
        t = tracks[i]
        if not t.get('id'):
            tracks[i]['id'] = i + 1
        
        l = f"{tracks[i]['id']}. {t.get('title')}"

        if t.get('artist'):
            l = f"{l}, {t.get('artist')}"

        l = f"{l}, {t.get('start')}-{t.get('end', 'END')}"
        
        print(l)

def generate_playlist(playlist_name, tracks):
    """ Generate a mp3 playlist of the ordered tracks """

    with open(playlist_name, "w") as pl:
        pl.write("#EXTM3U")
        for t in tracks:
            trackfilename = get_valid_track_filename(t.get('id'), t.get('title'), t.get('artist'))
            track_len = f"ffprobe -show_streams {trackfilename} -v fatal | grep duration= | cut -d '=' -f 2 | cut -d '.' -f 1"
            secs_output = subprocess.run(track_len, shell=True, stdout=subprocess.PIPE, encoding='utf8')
            secs = secs_output.stdout.strip()
            # #EXTINF:419,Alice in Chains - Rotten Apple
            pl.write(f"#EXTINF:{secs},{t.get('artist')} - {t.get('title')}\n")
            pl.write(f"{trackfilename}\n")


def get_valid_track_filename(id, title, artist):
    """ Get a sane filename for a saved track """
    return get_valid_filename(f"{id}.{title}-{artist}.mp3")

def call_external_program(desc, cmd, show=False):
    """ Call an external program and show the std output """
    print(f"{desc}")
    print(f"   {cmd}")
    p = subprocess.Popen(cmd, shell=True, stderr=subprocess.PIPE, encoding='utf8')
    if show:
        ## But do not wait till finish, start displaying output immediately ##
        while True:
            out = p.stderr.read(1)
            if out == '' and p.poll() != None:
                break
            if out != '':
                # if show:
                sys.stdout.write(out)
                sys.stdout.flush()
    else:
        out, err = p.communicate()


# Check program dependencies
is_tool("youtube-dl")
is_tool("ffmpeg")
is_tool("id3")

url = ""
artist = ""
album = ""
tracks = []

# work with a default "playlist.txt" file, or a given one
# Playlist file format:
# youtube file url
# Album Name
# Artist Name
# 1. some title (some artist) 00:00
# 2. other title (other artist) 05:46
# ...
playlist_file = sys.argv[1] if len(sys.argv) > 1 else "playlist.txt"

# parse the playlist file
lineno = 0
with open(playlist_file, "r") as f:
    for line in f:
        # First line contains the youtube url to download
        if lineno == 0:
            url = line.strip()
        elif lineno == 1:
            album = line.strip()
        elif lineno == 2:
            artist = line.strip()
        else:
           tracks.append(extract_track_info(line.strip()))
        lineno += 1

# add end times to each track
for i in range(len(tracks)-1):
    tracks[i]['end'] = tracks[i+1]['start']
    
print("This is how I parsed the playlist file:\n")

print_tracks(tracks)

answer = "z"
while answer.lower() not in ("y", "n", "yes", "no"):
    answer = input("\nDoes it look right? Should I proceed? (y/n) ")

if answer in ("n", "no"):
    sys.exit(0)

# Download youtube file
outfile = get_valid_filename(f"{album}-{artist}")
cmd = f"youtube-dl --no-post-overwrites -x --audio-format mp3 --audio-quality 3 -o {outfile}.%\(ext\)s {url}"
call_external_program("Downloading file from youtube", cmd)


# Iterate over parsed tracks
for t in tracks:
    # Cut to length
    trackfilename = get_valid_track_filename(t.get('id'), t.get('title'), t.get('artist'))
    if t.get('end', ''):
        cut_command = f"ffmpeg -ss {t.get('start')} -to {t.get('end')} -i {outfile}.mp3 -c copy {trackfilename}"
    else:
        cut_command = f"ffmpeg -ss {t.get('start')} -i {outfile}.mp3 -c copy {trackfilename}"
    call_external_program(f"Cutting track {trackfilename} to size...", cut_command)

    # and add mp3 tags
    edit_mp3metata_cmd = f"id3 -n '{t.get('id')}' -t '{t.get('title')}' -a '{t.get('artist')}' -l '{album}' {trackfilename}"
    call_external_program("Adding mp3 tags", edit_mp3metata_cmd)


# generate an mp3 playlist
playlist_name = get_valid_filename(f"{album}-{artist}.m3u")
generate_playlist(playlist_name, tracks)

#remove the large continuous .mp3 file
os.remove(f"{outfile}.mp3")
