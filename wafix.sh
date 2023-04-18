#!/bin/bash

pwda=$PWD

check_OS() {
    if [[ -f /etc/os-release ]]; then
        # freedesktop.org and systemd
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    
    elif type lsb_release >/dev/null 2>&1; then
        # linuxbase.org
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)

    elif [ -f /etc/lsb-release ]; then
        # For some versions of Debian/Ubuntu without lsb_release command
        . /etc/lsb-release
        OS=$DISTRIB_ID
        VER=$DISTRIB_RELEASE

    elif [ -f /etc/debian_version ]; then
        # Older Debian/Ubuntu/etc.
        OS=Debian
        VER=$(cat /etc/debian_version)

    else 
        # Fall back to uname, e.g. "Linux <version>", also works for BSD, etc.
        OS=$(uname -s)
        VER=$(uname -r)
    fi
}

setup_firmware(){
    if [[ "$OS" =~ Ubuntu ]] || [[ "$OS" =~ Debian ]] || [[ "$OS" =~ kali]]; then
        # Update package index
        sudo apt update
        # Install firmware
        sudo apt install -y firmware-iwlwifi
        # Load driver
        sudo modprobe -vv iwlwifi
        # Add wafix.sh to crontab
        if ! crontab -l | grep -q "@reboot $(pwda)/wafix.sh"; then
            (crontab -l; echo "@reboot $(pwda)/wafix.sh") | crontab - && echo "[+] Added wafix.sh to crontab"
        else
         echo "[-] wafix.sh is already in the crontab file"
    elif [[ "$OS" =~ Arch ]]; then
        # Update package index
        sudo pacman -Syu
        # Install firmware
        sudo pacman -S --noconfirm firmware-iwlwifi
        # Load driver
        sudo modprobe -vv iwlwifi
        # Add wafix.sh to crontab
        if ! crontab -l | grep -q "@reboot $(pwda)/wafix.sh"; then
            (crontab -l; echo "@reboot $(pwda)/wafix.sh") | crontab - && echo "[+] Added wafix.sh to crontab"
        else
            echo "[-] wafix.sh is already in the crontab file"
        fi
            exit 0
    elif [[ "$OS" =~ Fedora ]]; then
        # Update package index
        sudo dnf update
        # Install firmware
        sudo dnf install -y firmware-iwlwifi
        # Load driver
        sudo modprobe -vv iwlwifi
        # Add wafix.sh to crontab
        if ! crontab -l | grep -q "@reboot $(pwda)/wafix.sh"; then
            (crontab -l; echo "@reboot $(pwda)/wafix.sh") | crontab - && echo "[+] Added wafix.sh to crontab"
        else
            echo "[-] wafix.sh is already in the crontab file"
        fi
        exit 0
    elif [[ "$OS" =~ CentOS ]]; then
        # Update package index
        sudo yum update
        # Install firmware
        sudo yum install -y firmware-iwlwifi
        # Load driver
        sudo modprobe -vv iwlwifi
        # Add wafix.sh to crontab
        if ! crontab -l | grep -q "@reboot $(pwda)/wafix.sh"; then
            (crontab -l; echo "@reboot $(pwda)/wafix.sh") | crontab - && echo "[+] Added wafix.sh to crontab"
        else
            echo "[-] wafix.sh is already in the crontab file"
        fi
        exit 0
    fi
}

fix_wireless_adapter() {
    if [[ "$OS" =~ Ubuntu ]]; then
        setup_firmware
        # Restart networking
        sudo service network-manager restart
        echo "[+] Networking restarted" 
        exit 0
    elif [[ "$OS" =~ Debian ]]; then
        setup_firmware
        # Restart networking
        sudo service network-manager restart
        echo "[+] Networking restarted"
        exit 0
    elif [[ "$OS" =~ kali ]]; then
        setup_firmware
        # Restart networking
        sudo service NetworkManager restart
        echo "[+] Networking restarted"
        exit 0
    elif [[ "$OS" =~ Arch ]]; then
        setup_firmware
        # Restart networking
        sudo systemctl restart NetworkManager
        echo "[+] Networking restarted"
        exit 0
    elif [[ "$OS" =~ Fedora ]]; then
        setup_firmware
        # Restart networking
        sudo systemctl restart NetworkManager
        echo "[+] Networking restarted"
        exit 0
    elif [[ "$OS" =~ CentOS ]]; then
        setup_firmware
        # Restart networking
        sudo systemctl restart NetworkManager
        echo "[+] Networking restarted"
        exit 0
    fi
}
    
check_OS
fix_wireless_adapter
