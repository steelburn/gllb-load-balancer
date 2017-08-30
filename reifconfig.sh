#!/bin/bash
########################################
# Generic Linux Load Balancer
# by : steelburn
# @  : steelburn(at)blogspaper(dot)org
########################################

CONFIGFILE=/etc/gllb/config

source $CONFIGFILE

ifconfig $adapter $ipaddress netmask $netmask
route del default
route add default gw $gateway

mv /etc/resolv.conf /etc/resolv.old
touch /etc/resolv.conf
echo "#/etc/resolv.conf replaced by gllb script. Any modification done here will be replaced upon reboot." > /etc/resolv.conf
for nameserver in $nameservers
do
	echo "nameserver $nameserver" >> /etc/resolv.conf
done
