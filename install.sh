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


chmod +x install-nlb.sh
echo "We need root password again."
su -c "./install-nlb.sh"