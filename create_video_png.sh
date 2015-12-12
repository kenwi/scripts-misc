#/bin/bash

# Create a full HD video from all PNG's in current directory. First and second argument equals FPS and output name, respectively
# Usage example for 60fps video: repos/scripts-misc/create_video_png.sh 60 output.mp4

mencoder "mf://*.png" -mf fps=$1:type=png -ovc lavc -lavcopts vcodec=mpeg4:mbd=2:trell:vbitrate=7000 -vf scale=1280:720 -oaccopy -o $2

