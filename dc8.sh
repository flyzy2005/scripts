#!/bin/bash

### 
#  本脚本用于自动切换至DC8机房
#  脚本使用方法参考：https://www.bwgyhw.com/bandwagonhost-dc8-scripts/
###

B=USCA_8
red='\033[0;31m'
green='\033[0;32m'
yellow='\033[0;33m'
plain='\033[0m'

info() {
    A=(`wget -qO- "https://api.64clouds.com/v1/migrate/getLocations?&veid=${VEID}&api_key=${API_KEY}" | cut -d":" -f3 | cut -d"," -f1 | sed 's/\"//g'`)
}

if [ "$#" -ne 2 ]; then
	echo -e "[${red}Error${plain}] Please input VEID and API_KEY! For deatil, please check: https://www.bwgyhw.com/bandwagonhost-dc8-scripts/"
	exit 0
fi

VEID=$1
API_KEY=$2

info
while [[ $A != $B ]]
do
    echo $A
    echo $B
    wget -qO- "https://api.64clouds.com/v1/migrate/start?location=${B}&veid=${VEID}&api_key=${API_KEY}"
    sleep 30s
    info
done
