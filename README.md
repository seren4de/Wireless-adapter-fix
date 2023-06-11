# Wireless Adapter Fix

## Checking the wireless adapter

First, check if the wireless adapter is being detected by the system:

```sh
$ ifconfig wlan0
wlan0: error fetching interface information: Device not found
```

```sh
$ lspci | grep -i network 
00:14.3 Network controller: Intel Corporation Comet Lake PCH CNVi WiFi
```

## Checking the driver

Check if the correct driver is installed:

```sh
$ sudo lshw -C network
  *-network UNCLAIMED       
       description: Network controller
       product: Comet Lake PCH CNVi WiFi
       vendor: Intel Corporation
       physical id: 14.3
       bus info: pci@0000:00:14.3
       version: 00
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress msix cap_list
       configuration: latency=0
       resources: memory:c541c000-c541ffff
  *-network
       description: Ethernet interface
       product: RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller
       vendor: Realtek Semiconductor Co., Ltd.
       physical id: 0
       bus info: pci@0000:05:00.0
       logical name: eth0
       version: 15
       serial: 24:4b:fe:ba:d8:f1
       capacity: 1Gbit/s
       width: 64 bits
       clock: 33MHz
       capabilities: pm msi pciexpress msix bus_master cap_list ethernet physical tp mii 10bt 10bt-fd 100bt 100bt-fd 1000bt-fd autonegotiation
       configuration: autonegotiation=on broadcast=yes driver=r8169 driverversion=6.1.0-kali7-amd64 latency=0 link=no multicast=yes port=twisted pair
       resources: irq:18 ioport:3000(size=256) memory:c5204000-c5204fff memory:c5200000-c5203fff
  *-network
       description: Ethernet interface
       physical id: d
       bus info:<IPAddress>
       logical name:<IPAddress>
       serial:<IPAddress>
       capabilities:<IPAddress>
       configuration:<IPAddress>
```

According to the output of `lshw -C network`, it appears that the Intel wireless adapter is detected by the system but is listed as `*-network UNCLAIMED`. This usually means that the driver for the device is not installed or loaded.

## Identifying the model

Identify the exact model of your Intel wireless adapter:

```sh
$ lspci -vnn | grep -i network 
00:<IPAddress> Network controller [0280]: Intel Corporation Comet Lake PCH CNVi WiFi [8086:<IPAddress>]
```

## Installing the firmware

Update your package list:

```sh 
$ sudo apt update 
```

Install the firmware for your Intel wireless adapter:

```sh 
$ sudo apt install firmware-iwlwifi 
```

Load the driver:

```sh 
$ sudo modprobe iwlwifi 
```

## Fixing the issue

To fix this issue permanently, you can add a script to run at startup using `crontab`:

```sh 
$ sudo crontab -e 
```

Add this line to the end of the file:

```
@reboot /$HOME/wififix/fixw.sh 
```
