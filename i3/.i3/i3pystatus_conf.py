from i3pystatus import Status, get_module
from subprocess import call
#                 _                              _ _ _                _
#   ___ _   _ ___| |_ ___  _ __ ___     ___ __ _| | | |__   __ _  ___| | _____
#  / __| | | / __| __/ _ \| '_ ` _ \   / __/ _` | | | '_ \ / _` |/ __| |/ / __|
# | (__| |_| \__ \ || (_) | | | | | | | (_| (_| | | | |_) | (_| | (__|   <\__ \
#  \___|\__,_|___/\__\___/|_| |_| |_|  \___\__,_|_|_|_.__/ \__,_|\___|_|\_\___/
#

# fonts and font cheatsheet from:
# https://github.com/ryanoasis/nerd-fonts


col1 = "#60AED8"
col2 = "#A7D4A3"
col3 = "#F8EDC0"
col4 = "#FF9900"
col5 = "#60AED8"
col6 = "#A7D4A3"
col7 = "#F8EDC0"
col8 = "#FF9900"
col9 = "#60AED8"
col10 = "#A7D4A3"
col11 = "#F8EDC0"
col12 = "#FF9900"
col13 = "#60AED8"
col14 = "#A7D4A3"
col15 = "#F8EDC0"
col16 = "#FF9900"
col17 = "#60AED8"
col18 = "#A7D4A3"
col19 = "#F8EDC0"
col20 = "#FF9900"


@get_module
def switch_network_direction(self):
    self.graph_type = 'output' if self.graph_type == 'input' else 'input'
    self.format_up = self.format_up[:-1] + \
        ('' if self.graph_type == 'input' else '')


@get_module
def switch_locale(self):
    self.change_layout()
    call(["xmodmap", "/home/me/.Xmodmap"])


status = Status()


#  _   _
# | |_(_)_ __ ___   ___
# | __| | '_ ` _ \ / _ \
# | |_| | | | | | |  __/
#  \__|_|_| |_| |_|\___|
#

# Displays clock like this:
# Tue 30 Jul 11:59:46 PM KW31
#                          ^-- calendar week
status.register("clock",
                format=" %a %d %b %T",
                color=col19)


#             _
# __   _____ | |_   _ _ __ ___   ___
# \ \ / / _ \| | | | | '_ ` _ \ / _ \
#  \ V / (_) | | |_| | | | | | |  __/
#   \_/ \___/|_|\__,_|_| |_| |_|\___|

status.register("pulseaudio",
                format="🔊 {volume}",
                on_upscroll="decrease_volume",
                on_downscroll="increase_volume",
                color_unmuted=col18)

#  _                _    _ _       _     _
# | |__   __ _  ___| | _| (_) __ _| |__ | |_
# | '_ \ / _` |/ __| |/ / | |/ _` | '_ \| __|
# | |_) | (_| | (__|   <| | | (_| | | | | |_
# |_.__/ \__,_|\___|_|\_\_|_|\__, |_| |_|\__|
#                            |___/
#

status.register("backlight",
                format=" {percentage}%",
                backlight="intel_backlight",
                # interval=120,
                on_upscroll="darker",
                on_downscroll="lighter",
                color=col17)

#  _           _   _
# | |__   __ _| |_| |_ ___ _ __ _   _
# | '_ \ / _` | __| __/ _ \ '__| | | |
# | |_) | (_| | |_| ||  __/ |  | |_| |
# |_.__/ \__,_|\__|\__\___|_|   \__, |
#                               |___/
#

# The battery monitor has many formatting options, see README for details

# This would look like this, when discharging (or charging)
# ↓14.22W 56.15% [77.81%] 2h:41m
# And like this if full:
# =14.22W 100.0% [91.21%]
#
# This would also display a desktop notification (via D-Bus) if the percentage
# goes below 5 percent while discharging. The block will also color RED.
# If you don't have a desktop notification demon yet, take a look at dunst:
#   http://www.knopwob.org/dunst/
# status.register("battery",
#    format="{status}/{consumption:.2f}W {percentage:.2f}% [{percentage_design:.2f}%]
#{remaining:%E%hh:%Mm}",
#    alert=True,
#    alert_percentage=5,
#    status={
#        "DIS": "↓",
#        "CHR": "↑",
#        "FULL": "=",
#    },)

# This would look like this:
# Discharging 6h:51m
status.register("battery",
                format="{status} {remaining:%E%hh:%Mm}",
                alert=True,
                alert_percentage=5,
                status={
                    "DIS":  "",
                    "CHR":  "",
                    "FULL": "",
                },
                color=col16)


#  _              _       _                         _
# | | _____ _   _| |__   | | __ _ _   _  ___  _   _| |_
# | |/ / _ \ | | | '_ \  | |/ _` | | | |/ _ \| | | | __|
# |   <  __/ |_| | |_) | | | (_| | |_| | (_) | |_| | |_
# |_|\_\___|\__, |_.__/  |_|\__,_|\__, |\___/ \__,_|\__|
#           |___/                 |___/

status.register("xkblayout",
                layouts=["us", "gr"],
                on_leftclick=switch_locale,
                )


#              _   _
#  _   _ _ __ | |_(_)_ __ ___   ___
# | | | | '_ \| __| | '_ ` _ \ / _ \
# | |_| | |_) | |_| | | | | | |  __/
#  \__,_| .__/ \__|_|_| |_| |_|\___|
#       |_|

status.register("uptime",
                format=" {days}d {hours}:{mins}",
                interval=60,
                color=col14)


#  _ __ ___   ___ _ __ ___   ___  _ __ _   _
# | '_ ` _ \ / _ \ '_ ` _ \ / _ \| '__| | | |
# | | | | | |  __/ | | | | | (_) | |  | |_| |
# |_| |_| |_|\___|_| |_| |_|\___/|_|   \__, |
#                                      |___/
#

status.register("mem",
                format="\uf1fe {percent_used_mem}%",
                warn_percentage=70,
                alert_percentage=90,
                interval=2,
                color=col13)


#  _                 _
# | | ___   __ _  __| |
# | |/ _ \ / _` |/ _` |
# | | (_) | (_| | (_| |
# |_|\___/ \__,_|\__,_|
#

# Shows the average load of the last minute and the last 5 minutes
# (the default value for format is used)
status.register("load",
                format=" {avg1} {avg5}",
                color=col12)

#                     _
#   ___ _ __  _   _  | |_ ___ _ __ ___  _ __
#  / __| '_ \| | | | | __/ _ \ '_ ` _ \| '_ \
# | (__| |_) | |_| | | ||  __/ | | | | | |_) |
#  \___| .__/ \__,_|  \__\___|_| |_| |_| .__/
#      |_|                             |_|
#

# Shows your CPU temperature, if you have a Intel CPU
status.register("temp",
                format=" {temp:.0f}°C",
                color=col11)

#      _ _
#   __| | |__   ___ _ __
#  / _` | '_ \ / __| '_ \
# | (_| | | | | (__| |_) |
#  \__,_|_| |_|\___| .__/
#                  |_|

# Displays whether a DHCP client is running
# status.register("runwatch",
#    name="DHCP",
#    path="/var/run/dhclient*.pid",)


#           _              _              _                      _
# __      _(_)_ __ ___  __| |  _ __   ___| |___      _____  _ __| | __
# \ \ /\ / / | '__/ _ \/ _` | | '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ /
#  \ V  V /| | | |  __/ (_| | | | | |  __/ |_ \ V  V / (_) | |  |   <
#   \_/\_/ |_|_|  \___|\__,_| |_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\

# Shows the address and up/down state of eth0. If it is up the address is shown in
# green (the default value of color_up) and the CIDR-address is shown
# (i.e. 10.10.10.42/24).
# If it's down just the interface name (eth0) will be displayed in red
# (defaults of format_down and color_down)
#
# Note: the network module requires PyPI package netifaces
status.register("network",
                interface="enp0s25",
                format_up=" {v4} {network_graph} ",
                format_down=" DOWN",
                graph_width=8,
                interval=2,
                on_leftclick=switch_network_direction,
                color_up=col10,
                start_color=col10,
                dynamic_color=True)

#           _          _                            _                      _
# __      _(_)_ __ ___| | ___  ___ ___   _ __   ___| |___      _____  _ __| | __
# \ \ /\ / / | '__/ _ \ |/ _ \/ __/ __| | '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ /
#  \ V  V /| | | |  __/ |  __/\__ \__ \ | | | |  __/ |_ \ V  V / (_) | |  |   <
#   \_/\_/ |_|_|  \___|_|\___||___/___/ |_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\

# Note: requires both netifaces and basiciw (for essid and quality)
# {v4}
status.register("network",
                interface="wlo1",
                format_up=" {quality:03.0f}% {essid} {network_graph} ",
                format_down=" DOWN",
                graph_width=8,
                interval=2,
                on_leftclick=switch_network_direction,
                color_up=col9,
                start_color=col9,
                dynamic_color=True)


#              _ _
#   ___  _ __ | (_)_ __   ___
#  / _ \| '_ \| | | '_ \ / _ \
# | (_) | | | | | | | | |  __/
#  \___/|_| |_|_|_|_| |_|\___|
#
# add: %sudo ALL=NOPASSWD: /usr/local/bin/esaConnect
# to sudoers to allow execution of script that needs sudo
status.register("shell",
                command="/home/me/dotfiles/bin/online.sh",
                error_color="#FF0000",
                on_leftclick="/usr/local/bin/esaConnect",
                interval=10,
                color=col8)


#      _ _     _
#   __| (_)___| | __  ___ _ __   __ _  ___ ___  ___
#  / _` | / __| |/ / / __| '_ \ / _` |/ __/ _ \/ __|
# | (_| | \__ \   <  \__ \ |_) | (_| | (_|  __/\__ \
#  \__,_|_|___/_|\_\ |___/ .__/ \__,_|\___\___||___/
#                        |_|

# Shows disk usage of /
status.register("disk",
                path="/",
                format=" /:{avail}G",
                color=col7)

status.register("disk",
                path="/home",
                format=": {avail}G, ",
                hints={"separator": False, "separator_block_width": 0},
                color=col6)


# Shows mpd status
# Format:
# Cloud connected▶Reroute to Remain
# status.register("mpd",
#    format="{title}{status}{album}",
#    status={
#        "pause": "▷",
#        "play": "▶",
#        "stop": "◾",
#    },)


#      _            _
#   __| | ___   ___| | _____ _ __
#  / _` |/ _ \ / __| |/ / _ \ '__|
# | (_| | (_) | (__|   <  __/ |
#  \__,_|\___/ \___|_|\_\___|_|

status.register("shell",
                command="/home/me/.i3/running_docker.sh",
                format=" {output}",
                color=col5)

#        _ _   _           _
#   __ _(_) |_| |__  _   _| |__
#  / _` | | __| '_ \| | | | '_ \
# | (_| | | |_| | | | |_| | |_) |
#  \__, |_|\__|_| |_|\__,_|_.__/
#  |___/

status.register("github",
                format=" {unread_count}",
                username="stratosgear",
                goto='notifications',
                color=col4)


status.run()
