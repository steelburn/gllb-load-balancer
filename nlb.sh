#!/bin/bash
# Original code to start load balancer
#

source /etc/gllb/config

# vip=`ifconfig eth0 | grep 'inet addr' | awk '{print substr($2,6)}'`
vip=$ipaddress

killall balance
sleep 1
echo -e "\nLoading load balancer...\n"

for port in $ports
do
balance -b ::ffff:$vip $port $targetip1 % $targetip2
done

