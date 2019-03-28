#!bin/bash
DLOCATION=/tmp/gllb-$RANDOM

# if this file does not exist, it's not Debian
if [[ ! -f /etc/debian_version ]]; then
    echo "You are not running on Debian. We don't want to work with you."
    exit
else
DVERSION=`cat /etc/debian_version`
fi

chksudo=`which sudo | wc -l`
GITURL=https://github.com/steelburn/gllb-load-balancer.git
SUDOTEMPFILE=/tmp/.abc-$RANDOM
echo "$USER ALL=(ALL:ALL) ALL" > $SUDOTEMPFILE


echo "Enter root passsword to install sudo and other tools."
su -c "apt-get -y install sudo net-tools git dialog balance && cat /etc/sudoers $SUDOTEMPFILE > /etc/sudoers"
rm $SUDOTEMPFILE

git clone $GITURL $DLOCATION
cd $DLOCATION

# We would want to make sure /etc/rc.local is around so that the next script works.
if [[ ! -f /etc/rc.local ]]; then
    $SUDO cp rc.local /etc/rc.local 
#    $SUDO cp rc-local.service /etc/systemd/system/rc-local.service 
    $SUDO chmod +x /etc/rc.local 
    $SUDO systemctl enable rc-local
    $SUDO systemctl start rc-local.service
fi

$SUDO chmod +x install-nlb.sh
su -c "./install-nlb.sh"