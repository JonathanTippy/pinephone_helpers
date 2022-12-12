#!/bin/bash
export NAME=Video_portrait_$(date +%Y-%m-%d_%H-%M-%S-%N)
export NUMBER=$(media-ctl -d /dev/media1 -p | grep -m 1 /dev/video | grep -o "\d")
export DISPLAY=:0

media-ctl -d /dev/media1 --set-v4l2 '"ov5640 4-004c":0[fmt:JPEG_1X8/640x480@1/30]'
v4l2-ctl --device /dev/video$NUMBER --set-fmt-video="width=640,height=480,pixelformat=JPEG"
#mkdir /tmp/videos_tmpfs
#mount /tmp/videos_tmpfs

gnome-session-inhibit --inhibit suspend gst-launch-1.0 -v -e \
   v4l2src device="/dev/video$NUMBER" \
      ! image/jpeg, width=640, height=480, framerate=30/1, format=JPEG \
      ! queue ! mux. \
   pulsesrc device="alsa_input.platform-sound.HiFi__hw_PinePhone_0__source" \
      ! audioconvert \
      ! audio/x-raw, rate=48000, channels=2, format=S16LE \
      ! queue ! mux. \
   qtmux name=mux ! filesink location=$HOME/Videos/VIDEO.mkv

echo hi!

gnome-session-inhibit --inhibit suspend gst-launch-1.0 \
   filesrc location=$HOME/Videos/VIDEO.mkv \
      ! qtdemux name=d \
            d. \
            ! queue \
            ! jpegdec ! videoflip method=clockwise \
            ! x264enc speed-preset=2 ! video/x-h264, profile=baseline ! queue ! mux. \
            d. \
            ! queue \
            ! audioconvert \
            ! lamemp3enc ! queue ! mux. \
   qtmux name=mux ! filesink location=$HOME/Videos/$NAME.mp4

gnome-session-inhibit --inhibit suspend rm $HOME/Videos/VIDEO.mkv

#gnome-session-inhibit --inhibit suspend cp /tmp/videos_tmpfs/$NAME.mp4 $HOME/Videos
#umount /tmp/videos_tmpfs
#rm /tmp/videos_tmpfs -r