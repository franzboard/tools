# Prepare Raspberry for ssh login via wifi

## 1. After flashing sd card, put the following files into /boot partition:
- ssh (empty)
- wpa_supplicant.conf:
```
country=DE
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
    ssid="my-essid"
    psk="my-pass"
}
```
## 2. After having logged into your Raspberry, open /etc/network/interfaces
Add the following lines for preventing wlan module sleep mode and for reconnecting 
after loss of signal.
```
wireless-power off
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
```

