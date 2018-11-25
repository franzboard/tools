#!/bin/bash
# Writes raw image to disk
# Only on Raspberry Pi with no other usb disk!
# Use at your own risk!!!
#
# Image file is located one level higher in hierarchy
# modify if needed
#
IMAGE=$(ls ../*.img)
echo "flash /dev/sda from $IMAGE"
dd if=$IMAGE  of=/dev/sda bs=4M status=progress




