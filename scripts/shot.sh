#!/bin/sh

fbgrab shot.png
convert shot.png -crop 650x230+58+45 -resize 768x576! -depth 8 shot.png
