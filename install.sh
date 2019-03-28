#!bin/bash

# if this file does not exist, it's not Debian
if [[ ! -f /etc/debian_version ]]; then
    echo "You are not running on Debian. We don't want to work with you."
    exit
else
DVERSION=`cat /etc/debian_version`
fi

chksudo=`which sudo | wc -l`
GITURL=https://github.com/steelburn/gllb-load-balancer.git
SUDOTEMPFILE=.abc 
echo "$USER ALL=(ALL:ALL) ALL" > $SUDOTEMPFILE

if [ "$chksudo" = "0" ]; then
echo "Enter root passsword to install sudo and other tools."
su -c "apt-get -y install sudo net-tools git && cat /etc/sudoers $SUDOTEMPFILE > /etc/sudoers"
fi
rm $SUDOTEMPFILE

chksudo=`which sudo | wc -l`
if [ "$chksudo" = "0" ]; then
    echo "Sudo somehow wasn't successfully installed."
    echo "Please install manually and rerun the script to continue."
    exit
else
SUDO='sudo'
fi

read -p "Enter download location: " -i "$PWD" DLOCATION
if [ "$DLOCATION" != "" ]; then
    $SUDO mkdir -p $DLOCATION
    echo "Location set to: $DLOCATION"
    else
    DLOCATION=$PWD/gllb
   $SUDO mkdir -p $DLOCATION 
   echo "Empty response. Location set to: $DLOCATION"
fi

git clone $GITURL $DLOCATION

cd $DLOCATION

# We would want to make sure /etc/rc.local is around so that the next script works.
if [[ ! -f /etc/rc.local ]]; then
    cp rc.local /etc/rc.local 
    cp rc-local.service /etc/systemd/system/rc-local.service 
    chmod +x /etc/rc.local 
    systemctl enable rc-local
    systemctl start rc-local.service
fi

$SUDO chmod +x install-nlb.sh
$SUDO ./install-nlb.sh