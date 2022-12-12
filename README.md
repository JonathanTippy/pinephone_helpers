# pinephone_helpers
some scripts and .desktop entries I made for my pinephone; they should work for any pinephone running postmarketOS

## restarters
bash scripts and .desktop files to restart the modem or the wifi because they sometimes stop working

## video
somehow there isn't a video app yet for the pinephone, so I wrote some scripts :) 

## sd card installer
just a little script to install an sd card. It must already be formatted to f2fs. I made it because I was tired of writing 10 fstab entries every time I reinstalled.

## How to install:
### restarters
- Save modem_restart.sh, wifi_restart.sh, modem_restart.desktop, and wifi_restart.desktop to ~/.local/share/applications
- chmod the scripts to be executable
- you may have to replace the home path in the .desktop files if your user is not "user"
### video
- Save video_landscape.sh, video_portrait.sh, stop_video.sh, video_landscape.desktop, video_portrait.desktop, and stop_video.desktop to ~/.local/share/applications
- chmod the scripts to be executable
- you may have to replace the home path in the .desktop files if your user is not "user"
### sd card installer
- run the script.
## Dependancies:
### restarters
- pkexec
### video
- gstreamer-tools
- gst-plugins-ugly
- v4l-utils
