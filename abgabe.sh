#!/bin/bash
# Abgabe vom Raspberry in die Windows-Testbox
echo -n "Windows-Username: "
read name

echo -n "Password: "
stty -echo; read pass; stty echo; echo

echo -n "Lehrer-Kurzzeichen: "
read lehrer
kz=$(echo $lehrer | tr {a-z] [A-Z])

echo "*** Hänge Testbox für $kz auf Ordner testbox ein ***"

[[ -d ~/testbox ]] || mkdir ~/testbox
sudo mount //172.16.90.203/Testbox$/$kz testbox/ -o username=$name,password=$pass,uid=$USER,gid=$USER
[[ -d ~/testbox/$name ]] || mkdir ~/testbox/$name
sudo umount testbox
sudo mount //172.16.90.203/Testbox$/$kz/$name testbox/ -o username=$name,password=$pass,uid=$USER,gid=$USER










