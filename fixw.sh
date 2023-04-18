#!/bin/bash

pwd=$PWD

# Update package index
sudo apt update

# Install firmware
sudo apt install -y firmware-iwlwifi

# Load driver
sudo modprobe -vv iwlwifi

# Add fixw.sh to crontab
if ! crontab -l | grep -q "@reboot $(pwd)/fixw.sh"; then
  (crontab -l; echo "@reboot $(pwd)/fixw.sh") | crontab - && echo "[+] Added fixw.sh to crontab"
else
  echo "[-] fixw.sh is already in the crontab file"
fi

# Restart networking
sudo service NetworkManager restart
echo "[+] Networking restarted"
exit 0