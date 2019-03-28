############################################
# Generic Linux Load Balancer
# by : steelburn
# @  : steelburn(at)blogspaper(dot)org
############################################

echo "This is a  simple installation script which will copy required files in their respective directories."
echo "It will also fetch and install missing packages (if any)."
read -p "Press ENTER to continue..." DUMMY

SUDO=''
if [ "$EUID" != "0" ]; then
    SUDO='sudo'
fi

echo "Installing dependencies..."
$SUDO apt-get -y install dialog balance 


echo "Installing GLLB..."
$SUDO mkdir -p /etc/gllb
$SUDO mkdir -p /opt/gllb
$SUDO cp -u config /etc/gllb
$SUDO cp -u run.sh /opt/gllb/gllb-run
$SUDO cp -u nlb.sh /opt/gllb/nlb.sh
$SUDO cp -u reifconfig.sh /opt/gllb/gllb-reifconfig
$SUDO chmod +x /opt/gllb/nlb.sh
$SUDO chmod +x /opt/gllb/gllb-run
$SUDO chmod +x /opt/gllb/gllb-reifconfig

$SUDO ln -fs /opt/gllb/gllb-run /usr/local/sbin
$SUDO ln -fs /opt/gllb/gllb-reifconfig /usr/local/sbin

WC=`grep gllb-run /etc/profile | wc -l`
if [ "$WC" = "0" ]; then $SUDO echo "gllb-run" >> /etc/profile; fi

WC1=`grep gllb-reifconfig /etc/rc.local | wc -l`
WC2=`grep nlb.sh /etc/rc.local | wc -l`

$SUDO cp /etc/rc.local /tmp/rc.local
$SUDO cp /etc/rc.local /etc/rc.local.old

$SUDO head --lines=1 /tmp/rc.local > /etc/rc.local
if [ "$WC1" = "0" ]; then $SUDO echo "/opt/gllb/gllb-reifconfig" >> /etc/rc.local; fi
if [ "$WC2" = "0" ]; then $SUDO echo "/opt/gllb/nlb.sh" >> /etc/rc.local; fi
$SUDO tail --lines=+2 /tmp/rc.local >> /etc/rc.local

echo "Installation completed. Please run 'gllb-run' to continue with configuration."

