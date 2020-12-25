#!/usr/bin/python

import re
import sys
from shutil import which
import shlex
import subprocess
from subprocess import Popen, PIPE
import os

# https://regex101.com/r/yxIeVd/5
regex = re.compile(
    r"^(?P<id>\d+.?)?\s*(?P<title>.*?)(\((?P<artist>.*)\))?\s*\(?(?P<hrs>\d?\d:)?(?P<mins>\d?\d):(?P<secs>\d\d)\)?\s*$"
)


class Albumify:
    def __init__(self):
        self.url = ""
        self.artist = ""
        self.album = ""
        self.tracks = []
        self.gms = True
        self.check_dependencies()

    def check_dependencies(self):
        self.is_tool("youtube-dl")
        self.is_tool("ffmpeg")
        self.is_tool("id3")
        # Google-music-scripts
        self.gms = self.is_tool("gms", optional=True)

    def is_tool(self, name, optional=False):
        """Check whether `name` is on PATH and marked as executable."""

        if not which(name):
            if optional:
                print(
                    f"You do not seem to have [{name}] on your path. Certain functionality will be disabled."
                )
                return False
            else:
                print(
                    f"You will need to have the [{name}] executable on your path. Exiting..."
                )
                sys.exit(-1)
        return True

    def get_valid_filename(self, s):
        """ Get a valid filename from a string"""
        s = str(s).strip().replace(" ", "_")
        return re.sub(r"(?u)[^-\w.]", "", s)

    def extract_track_info(self, track_line):
        """ Tries to parse a string line and extract track name, artist if exists
        and start time.
        Sample lines that can currently be handled are demonstrated at regex101 at:
        https://regex101.com/r/yxIeVd/4
        Basically looks like:
        "7. River tale (Silent Island) 22:01\n"

        """
        if not track_line:
            return

        match = regex.match(track_line)
        groups = match.groupdict()

        if groups.get("hrs"):
            start = f"{groups.get('hrs')}"
        else:
            start = f"00:"

        start = f"{start}{groups.get('mins')}:{groups.get('secs')}"
        groups["start"] = start

        # remove period from track id
        if groups.get("id"):
            groups["id"] = groups["id"][0:-1]

        # remove open/close parenthesis
        if groups.get("artist"):
            groups["artist"] = groups["artist"].replace("(", "")
            groups["artist"] = groups["artist"].replace(")", "").strip()
        else:
            groups["artist"] = self.artist

        groups["title"] = groups["title"].strip()

        return groups

    def print_tracks(self):
        """ Print the list of tracks so the user can validate if parsing was correct """

        print("This is how I parsed the playlist file:\n")

        print(f"Album Title: {self.album}")
        print(f"     Artist: {self.artist}\n")
        for i in range(len(self.tracks)):
            t = self.tracks[i]
            if not t.get("id"):
                self.tracks[i]["id"] = i + 1

            l = f"{self.tracks[i]['id']}. {t.get('title')}"

            if t.get("artist"):
                l = f"{l}, {t.get('artist')}"

            l = f"{l}, {t.get('start')}-{t.get('end', 'END')}"
            print(l)

    def generate_playlist(self, playlist_name, tracks):
        """ Generate a mp3 playlist of the ordered tracks """

        with open(playlist_name, "w") as pl:
            pl.write("#EXTM3U\n")
            for t in tracks:
                print(int(t.get("id")))
                trackfilename = self.get_valid_track_filename(
                    int(t.get("id")), t.get("title"), t.get("artist")
                )
                track_len = f"ffprobe -show_streams {trackfilename} -v fatal | grep duration= | cut -d '=' -f 2 | cut -d '.' -f 1"
                secs_output = subprocess.run(
                    track_len, shell=True, stdout=subprocess.PIPE, encoding="utf8"
                )
                secs = secs_output.stdout.strip()
                # #EXTINF:419,Alice in Chains - Rotten Apple
                pl.write(f"#EXTINF:{secs},{t.get('artist')} - {t.get('title')}\n")
                pl.write(f"{trackfilename}\n")

    def get_valid_track_filename(self, id, title, artist):
        """ Get a sane filename for a saved track """
        return self.get_valid_filename(f"{id:02d}.{title}-{artist}.mp3")

    def call_external_program(self, desc, cmd, show=False):
        """ Call an external program and show the std output """
        print(f"{desc}")
        print(f"   {cmd}")
        p = subprocess.Popen(cmd, shell=True, stderr=subprocess.PIPE, encoding="utf8")
        if show:
            ## But do not wait till finish, start displaying output immediately ##
            while True:
                out = p.stderr.read(1)
                if out == "" and p.poll() != None:
                    break
                if out != "":
                    # if show:
                    sys.stdout.write(out)
                    sys.stdout.flush()
        else:
            out, err = p.communicate()

    def parse_playlist_file(self, playlist_file):
        print(f"Parsing: {playlist_file}")

        # Playlist file format:
        # youtube file url
        # Album Name
        # Artist Name
        # 1. some title (some artist) 00:00
        # 2. other title (other artist) 05:46
        # ...
        lineno = 0
        with open(playlist_file, "r") as f:
            for line in f:
                # First line contains the youtube url to download
                if lineno == 0:
                    self.url = line.strip()
                elif lineno == 1:
                    self.album = line.strip()
                elif lineno == 2:
                    self.artist = line.strip()
                else:
                    i = self.extract_track_info(line.strip())
                    self.tracks.append(i)
                lineno += 1

        # add end times to each track
        for i in range(len(self.tracks) - 1):
            self.tracks[i]["end"] = self.tracks[i + 1]["start"]

        self.print_tracks()

        answer = "z"
        while answer.lower() not in ("y", "n", "yes", "no"):
            answer = input("\nDoes it look right? Should I proceed? (y/n) ")

        return answer.lower() in ("y", "yes")

    def download_cut_id(self):

        # Download youtube file
        outfile = self.get_valid_filename(f"{self.album}-{self.artist}")
        cmd = f"youtube-dl --no-post-overwrites -x --audio-format mp3 --audio-quality 3 -o {outfile}.%\(ext\)s {self.url}"
        self.call_external_program("Downloading file from youtube", cmd)

        # Iterate over parsed tracks
        for t in self.tracks:
            # Cut to length
            trackfilename = self.get_valid_track_filename(
                int(t.get("id")), t.get("title"), t.get("artist")
            )
            if t.get("end", ""):
                cut_command = f"ffmpeg -ss {t.get('start')} -to {t.get('end')} -i {outfile}.mp3 -c copy {trackfilename}"
            else:
                cut_command = f"ffmpeg -ss {t.get('start')} -i {outfile}.mp3 -c copy {trackfilename}"
            self.call_external_program(
                f"Cutting track {trackfilename} to size...", cut_command
            )

            # and add mp3 tags
            q_title = t.get("title").replace("'", r"\'")
            q_artist = t.get("artist").replace("'", r"\'")
            q_album = self.album.replace("'", r"\'")
            edit_mp3metata_cmd = (
                f"id3 -n '{t.get('id')}' -t '{q_title}' "
                + f"-a '{q_artist}' -l '{q_album}' {trackfilename}"
            )
            self.call_external_program("Adding mp3 tags", edit_mp3metata_cmd)

        # generate an mp3 playlist
        playlist_name = self.get_valid_filename(f"{self.album}-{self.artist}.m3u")
        self.generate_playlist(playlist_name, self.tracks)

        # remove the large continuous .mp3 file
        os.remove(f"{outfile}.mp3")

    def ask_upload(self):
        if self.gms:
            upload = "z"
            while upload.lower() not in ("y", "n", "yes", "no"):
                upload = input("\nUpload to Google Play Music (y/n) ")
            return upload.lower() in ("y", "yes")
        else:
            print(
                "If you had Google Music Scripts (google-music-scripts) installled "
                "I would have proposed uploading to your Google Play Music account too."
            )
            input("Press ENTER for now...")
            return False

    def upload(self):
        upload_cmd = f"gms upload --use-metadata --use-hash"
        self.call_external_program("Uploading to Google Play Music", upload_cmd)


if __name__ == "__main__":
    playlist_file = sys.argv[1] if len(sys.argv) > 1 else "playlist.txt"

    alb = Albumify()

    parsed_ok = alb.parse_playlist_file(playlist_file)

    if parsed_ok:
        # ask for uploading now, so we can do all the tasks right away and the
        # user can walk away from the process without having to answer more
        # questions later on.
        #upload = alb.ask_upload()
        alb.download_cut_id()

        # if upload:
        #     alb.upload()
