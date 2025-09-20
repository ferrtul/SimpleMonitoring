#!/bin/bash

HOSTNAME=$(hostname)
TIMEZONE="$(timedatectl | grep "Time zone" | awk '{print $3, $4, $5}')"

USER=$(whoami)
OS=$(lsb_release -d | awk -F"\t" '{print $2}')
DATE=$(date +"%d %b %Y %H:%M:%S")

UPTIME=$(uptime -p)
UPTIME_SEC=$(cat /proc/uptime | awk '{print int($1)}')

CIDR=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -n1)
IP=${CIDR%/*}
MASK=$(ipcalc "$CIDR" | awk '/Netmask:/ {print $2}')
GATEWAY=$(ip route | awk '/default/ {print $3}')

RAM_TOTAL=$(free -m | awk '/Память:/ {printf "%.3f GB", $2/1024}')
RAM_USED=$(free -m | awk '/Память:/ {printf "%.3f GB", $3/1024}')
RAM_FREE=$(free -m | awk '/Память:/ {printf "%.3f GB", $4/1024}')

SPACE_ROOT=$(df / | tail -1 | awk '{printf "%.2f MB", $2/1024}')
SPACE_ROOT_USED=$(df / | tail -1 | awk '{printf "%.2f MB", $3/1024}')
SPACE_ROOT_FREE=$(df / | tail -1 | awk '{printf "%.2f MB", $4/1024}')
