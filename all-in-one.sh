#!/bin/bash
# - Download Raspbian Image in case *.img is not present
# - Write raw image to disk 
# - enable ssh server
# - Set hostname if given
#
# **** Only on Raspberry Pi with no other usb disk! ****
# Execute with sudo ./all-in-one.ssh
# Use at your own risk!!!
#
# nr@bulme.at 2020

# set these if you want to configure wifi
SSID=""
PSK=""

# Modify Raspbian Download URL if needed
URL="https://downloads.raspberrypi.org/raspbian_latest"

if [ "$EUID" -ne 0 ]
	then echo "Please run with sudo"
	exit 1
fi

echo "*** DANGER!!! Only run on Raspberry!!! ***"
echo "[Interrupt with Ctrl-C]"

# Is there already an image file from earlier downloads?
if ls *.img &> /dev/null ; then
	IMAGE=$(ls *.img)
else
	echo "Downloading $URL"
	wget "$URL"
	unzip *.zip
	rm *.zip
	IMAGE=$(ls *.img)
fi

echo "flash /dev/sda from $IMAGE"
echo -n "Raspberry hostname: "
read new_hostname

# temporary directory for boot and root partitions on sd card
tempdir=$(mktemp -d -p .) || { echo "Cannot create $tempdir"; exit 1; }
mkdir $tempdir/raspi-{boot,root} ||  { echo "Cannot create $tempdir boot/root"; exit 1; }

# write img to sd card
ls /dev/sda &> /dev/null || { echo "No SD card"; exit 1; }
dd if=$IMAGE  of=/dev/sda bs=4M status=progress
# sync
echo "sd card flashing finished!"

mount /dev/sda1 $tempdir/raspi-boot || { echo "Cannot mount boot"; exit 1; }
mount /dev/sda2 $tempdir/raspi-root || { echo "Cannot mount root"; exit 1; }

# configure host name if given
if [ ! -z "$new_hostname" ]; then
	echo $new_hostname > $tempdir/raspi-root/etc/hostname
	sed -i "s/127.0.1.1.*raspberrypi/127.0.1.1\t$new_hostname/g" $tempdir/raspi-root/etc/hosts
fi
# enable ssh server
touch $tempdir/raspi-boot/ssh

# configure wifi
if [ ! -z "$SSID" ] && [ ! -z "$PSK" ] ; then
echo "configure WIFI"
cat << EOF > $tempdir/raspi-boot/wpa_supplicant.conf
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=AT

network={
        ssid="$SSID"
        psk="$PSK"
}
EOF
fi

umount $tempdir/raspi-boot
umount $tempdir/raspi-root

rm -rf $tempdir

echo "configuration finished!"
echo "*** remove SD card from adaptor ***"







