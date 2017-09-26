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
## 2. After having logged into your Raspberry, open /etc/network/interfaces and
add the following lines:
```
wireless-power off
wpa-roam /etc/wpa_supplicant/wpa_supplicant.conf
```

