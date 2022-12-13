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
## Dependancies:
### restarters
- polkit-common
#### install
- sudo apk add polkit-common
### video
- gstreamer-tools
- gst-plugins-ugly
- v4l-utils
#### install
- sudo apk add gstreamer-tools gst-plugins-ugly v4l-utils
### sshfs mounter
- sshfs
- nmap
- libnotify
#### install
##### debian
- sudo apt install sshfs nmap libnotify
##### arch
- sudo pacman -S sshfs nmap libnotify
## How to install:
### restarters
- Save modem_restart.sh, wifi_restart.sh, modem_restart.desktop,
- and wifi_restart.desktop to ~/.local/share/applications:
- cd ~/Downloads
- git clone https://github.com/JonathanTippy/pinephone_helpers pinephone_helpers
- cp ~/Downloads/pinephone_helpers/modem_restart.sh ~/Downloads/pinephone_helpers/wifi_restart.sh \
- ~/Downloads/pinephone_helpers/modem_restart.desktop ~/Downloads/pinephone_helpers/wifi_restart.desktop \
- ~/.local/share/applications
- chmod the scripts to be executable:
- chmod +x ~/.local/share/applications/modem_restart.sh ~/.local/share/applications/wifi_restart.sh
- you may have to replace the home path in the .desktop files if your user is not "user":
- editor ~/.local/share/applications/wifi_restart.desktop
- editor ~/.local/share/applications/modem_restart.desktop
- don't forget to clean up the files:
- rm -Rf ~/Downloads/pinephone_helpers/
### video
- Save video_landscape.sh, video_portrait.sh, stop_video.sh, video_landscape.desktop,
- video_portrait.desktop, and stop_video.desktop to ~/.local/share/applications:
- cd ~/Downloads
- git clone https://github.com/JonathanTippy/pinephone_helpers pinephone_helpers
- cp ~/Downloads/pinephone_helpers/video_landscape.sh ~/Downloads/pinephone_helpers/video_portrait.sh \
- ~/Downloads/pinephone_helpers/stop_video.sh ~/Downloads/pinephone_helpers/video_landscape.desktop \
- ~/Downloads/pinephone_helpers/video_portrait.desktop ~/Downloads/pinephone_helpers/stop_video.desktop \
- ~/.local/share/applications
- chmod the scripts to be executable:
- chmod +x ~/.local/share/applications/video_landscape.sh ~/.local/share/applications/video_portrait.sh \
- ~/.local/share/applications/stop_video.sh
- you may have to replace the home path in the .desktop files if your user is not "user":
- editor ~/.local/share/applications/stop_video.desktop
- editor ~/.local/share/applications/video_portrait.desktop
- editor ~/.local/share/applications/video_landscape.desktop
- don't forget to clean up the files:
- rm -Rf ~/Downloads/pinephone_helpers/
### sd card installer
- save the script to your pinephone:
- cd ~/Downloads
- git clone https://github.com/JonathanTippy/pinephone_helpers pinephone_helpers
- chmod the script to be executable:
- chmod +x ~/Downloads/pinephone_helpers/sd_card_installer.sh
- run the script:
- bash ~/Downloads/pinephone_helpers/sd_card_installer.sh
- don't forget to clean up the files:
- rm -Rf ~/Downloads/pinephone_helpers/
### sshfs mounter
- this one's for your pc!
- first, make sure you follow the instructions at https://wiki.postmarketos.org/wiki/SSH
- so that you can connect to ssh without being asked for a password.
- save phone_sshfs_mounter.sh on your pc:
- cd ~/Downloads
- git clone https://github.com/JonathanTippy/pinephone_helpers pinephone_helpers
- chmod the script to be executable:
- chmod +x ~/Downloads/pinephone_helpers/phone_sshfs_mounter.sh
- edit the file with your favorite text editor:
- editor ~/Downloads/pinephone_helpers/phone_sshfs_mounter.sh
- either change the phone's ip, or edit the line " export WIFI_PINEPHONE_IP=10.10.10.76 " to reflect what ip the phone has when it is connected to wifi.
- you can repeat this for the LAN and ETH lines. LAN is for when the pinephone is on your local network via ethernet.
- ETH is for when the phone is connected directly to your pc via ethernet.
- if your user is not "user", make sure to edit $PINEPHONE_SSHFS_USER to reflect that.
- if you don't want it in your downloads folder, you can safely copy it to /usr/local/bin:
- sudo cp ~/Downloads/pinephone_helpers/phone_sshfs_mounter.sh /usr/local/bin
- use your OS to make phone_sshfs_mounter.sh run on login. for instance on manjaro you would add it to the "session and startup" "Application Autostart" tab.
- if you want, you can also just run the program in your terminal:
- bash ~/Downloads/pinephone_helpers/phone_sshfs_mounter.sh
- or:
- bash phone_sshfs_mounter.sh
- if you moved the script out of your downloads, you can delete the files:
- rm -Rf ~/Downloads/pinephone_helpers/
