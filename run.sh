#!/bin/bash
########################################
# Generic Linux Load Balancer
# by : steelburn
# @  : steelburn(at)blogspaper(dot)org
########################################

TEMP=/tmp/balretval$$
CONFIGFILE=/etc/gllb/config
NLBSCRIPT=/opt/gllb/nlb.sh
REIFCONFIG=/opt/gllb/gllb-reifconfig

update_config() {
	mv $CONFIGFILE $CONFIGFILE.`date +Y%m%d.%H%M.old`
	touch $CONFIGFILE
	echo "#Config file created on: `date +%Y%m%d.%H%M` by automation script" >> $CONFIGFILE
	echo -e "targetip1=\"$targetip1\"" >> $CONFIGFILE
	echo -e "targetip2=\"$targetip2\"" >> $CONFIGFILE
	echo -e "ports=\"$ports\"" >> $CONFIGFILE
	echo -e "\n" >> $CONFIGFILE
	echo -e "adapter=\"$adapter\"" >> $CONFIGFILE
	echo -e "ipaddress=\"$ipaddress\"" >> $CONFIGFILE
	echo -e "netmask=\"$netmask\"" >> $CONFIGFILE
	echo -e "gateway=\"$gateway\"" >> $CONFIGFILE
	echo -e "nameservers=\"$nameservers\"" >> $CONFIGFILE
	dialog --backtitle "Generic Linux Load Balancer" \
		--title "INFORMATION" \
        	--msgbox "Configuration has been saved." 10 60	
}

apply_config() {
	$REIFCONFIG
	$NLBSCRIPT
        dialog --backtitle "Generic Linux Load Balancer" \
                --title "INFORMATION" \
                --msgbox "New configuration has been applied." 10 60
}

change_ifconfig() {
v=8
while [ $v -ne 0 ]; do
dialog --backtitle "Generic Linux Load Balancer" \
	--title "Network configuration" \
	--menu "Select configuration to change" 16 60 12 \
	"1" "Adapter: ($adapter)" \
	"2" "Host IP: ($ipaddress)" \
	"3" "Subnet mask: ($netmask)" \
	"4" "Gateway: ($gateway)" \
	"5" "Nameservers: ($nameservers)" \
	"6" "Reload configuration from $CONFIGFILE" \
	"7" "Apply changes" \
	"0" "Return to previous menu" 2>$TEMP
v=`cat $TEMP`

	case $v in 
		1)
		dialog --title "Network Configuration" \
			--inputbox "New Adapter: " 6 30 "$adapter" 2>$TEMP
		adapter=`cat $TEMP`;;
		2)
		dialog --title "Network Configuration" \
			--inputbox "New IP Address: " 6 30 "$ipaddress" 2>$TEMP
		ipaddress=`cat $TEMP`;;
		3)
		dialog --title "Network Configuration" \
			--inputbox "New Subnet: " 6 30 "$netmask" 2>$TEMP
		netmask=`cat $TEMP`;;
		4)
 		dialog --title "Network Configuration" \
			--inputbox "New Gateway: " 6 30 "$gateway" 2>$TEMP
		gateway=`cat $TEMP`;;
		5)
		dialog --title "Network Configuration" \
			--inputbox "New Nameservers: " 6 30 "$nameservers" 2>$TEMP
		nameservers=`cat $TEMP`;;
		6)
		source $CONFIGFILE;;
		7)
		update_config
		apply_config;;
	esac
done

}

check_status() {
	dialog --backtitle "Generic Linux Load Balancer" \
	--title "STATUS" \
	--msgbox \
 	"`ps x | awk '{ print $5,"PID:"$1,"Port:"$8,"IP:"substr($7,8) }' | grep ^balance`" 10 60
}

change_balancer() {
dialog --backtitle "Generic Linux Load Balancer" \
	--msgbox "Sorry. Load balancer selection not available yet." 10 60
}

configure_balancer() {
v=8
while [ $v -ne 0 ]; do
dialog --backtitle "Generic Linux Load Balancer" \
        --title "Load Balancer Configuration" \
        --menu "Select task" 18 60 16 \
        "1" "Set Target IP#1 ($targetip1)" \
	"2" "Set Target IP#2 ($targetip2)" \
	"3" "Set ports ($ports)" \
	"4" "Reload configuration from $CONFIGFILE" \
	"5" "Apply changes" \
	"0" "Return to previous menu" 2>$TEMP
v=`cat $TEMP`
	case $v in
		1)
		dialog --title "Load Balancer Configuration" \
		--inputbox "New Target IP #1: " 6 30 "$targetip1" 2>$TEMP
		targetip1=`cat $TEMP`;;
		2)
		dialog --title "Load Balancer Configuration" \
		--inputbox "New Target IP #2: " 6 30 "$targetip2" 2>$TEMP
		targetip2=`cat $TEMP`;;
		3)
		dialog --title "Load Balancer Configuration" \
		--inputbox "New ports: " 6 30 "$ports" 2>$TEMP
		ports=`cat $TEMP`;;
		4)
                source $CONFIGFILE;;
                5)
                update_config
                apply_config;;
	esac

done
}

main_menu() {
currentip=`ifconfig | grep 'global' | awk '{print substr($2,6)}'`
source $CONFIGFILE

dialog --backtitle "Generic Linux Load Balancer" \
	--title "MAIN MENU" \
	--no-ok --no-cancel \
	--menu "Select task" 18 60 16 \
	"1" "Change Network Config ($currentip)" \
	"2" "Change load balancer ($balancer)" \
	"3" "Configure load balancer" \
	"4" "Reload Service" \
	"5" "Check Status" \
        "-" "-----------------------------------" \
	"7" "Reboot System" \
	"8" "Poweroff System" \
        "-" "-----------------------------------" \
	"9" "Temporary exit to Shell" \
	"0" "Permanent exit to Shell" 2> $TEMP
retval=$?

val=`cat $TEMP`
case $val in
	1) change_ifconfig;;
	2) change_balancer;;
	3) configure_balancer;;
	4) $NLBSCRIPT;;
	5) check_status;;
	7) reboot;;
	8) poweroff;;
	9) echo "You are now in shell mode. Type 'exit' to return to MAIN MENU'" ; /bin/bash;;
	0) echo "Bye! Anytime you want to come back to the menu, type 'gllb-run'" ; exit 1;;
	esac
 }


if (( $EUID != 0 )); then
    echo "Please run as root."
	exit
fi

while true 
do
	main_menu
done

