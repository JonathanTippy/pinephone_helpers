# pinephone_helpers
some scripts and .desktop entries I made for my pinephone; they should work for any pinephone running postmarketOS

## restarters
bash scripts and .desktop files to restart the modem or the wifi because they sometimes stop working

## video
somehow there isn't a video app yet for the pinephone, so I wrote some scripts :) 

## sd card installer
just a little script to install an sd card. It must already be formatted to f2fs. I made it because I was tired of writing 10 fstab entries every time I reinstalled.

## sshfs mounter
at the moment there is no good way to get mtp working for the pinephone, so I wrote a script that automatically mounts your phone's filesystem via ssh when it is available; it's just as convenient as mtp!
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
### sshfs mounter
- this one's for your pc!
- first, make sure you follow the instructions at https://wiki.postmarketos.org/wiki/SSH so that you can connect to ssh without being asked for a password.
- save phone_sshfs_mounter.sh wherever you likeon your pc.
- edit the file with your favorite text editor.
- either change the phone's ip, or edit the line " export WIFI_PINEPHONE_IP=10.10.10.76 " to reflect what ip the phone has when it is connected to wifi.
- you can repeat this for the LAN and ETH lines. LAN is for when the pinephone is on your local network via ethernet.
- ETH is for when the phone is connected directly to your pc via ethernet.
- if your user is not "user", make sure to edit $PINEPHONE_SSHFS_USER to reflect that.
- use your OS to make phone_sshfs_mounter.sh run on login. for instance on manjaro you would add it to the "session and startup" "Application Autostart" tab.
- if you want, you can also just run the program in your terminal.
## Dependancies:
### restarters
- pkexec
### video
- gstreamer-tools
- gst-plugins-ugly
- v4l-utils
### sshfs mounter
- sshfs
- nmap
- libnotify
