############################################
# Generic Linux Load Balancer
# by : steelburn
# @  : steelburn(at)blogspaper(dot)org
############################################

echo "This is a  simple installation script which will copy required files in their respective directories."
echo "It will also fetch and install missing packages (if any)."
read -p "Press ENTER to continue..." 

echo "Checking and installing dependencies..."
chkdialog=`which dialog | wc -l`
chkbalance=`which balance | wc -l`
if [ "$chkdialog" = "0" ]; then apt-get -y install dialog ;  fi
if [ "$chkbalance" = "0" ]; then apt-get -y install balance ; fi


echo "Installing GLLB..."
mkdir -p /etc/gllb
mkdir -p /opt/gllb
cp -u config /etc/gllb
cp -u run.sh /opt/gllb/gllb-run
cp -u nlb.sh /opt/gllb/nlb.sh
cp -u reifconfig.sh /opt/gllb/gllb-reifconfig
chmod +x /opt/gllb/nlb.sh
chmod +x /opt/gllb/gllb-run
chmod +x /opt/gllb/gllb-reifconfig

ln -fs /opt/gllb/gllb-run /usr/local/sbin
ln -fs /opt/gllb/gllb-reifconfig /usr/local/sbin

WC=`grep gllb-run /etc/profile | wc -l`
if [ "$WC" = "0" ]; then echo "gllb-run" >> /etc/profile; fi

WC1=`grep gllb-reifconfig /etc/rc.local | wc -l`
WC2=`grep nlb.sh /etc/rc.local | wc -l`

cp /etc/rc.local /tmp/rc.local
cp /etc/rc.local /etc/rc.local.old

head --lines=1 /tmp/rc.local > /etc/rc.local
if [ "$WC1" = "0" ]; then echo "/opt/gllb/gllb-reifconfig" >> /etc/rc.local; fi
if [ "$WC2" = "0" ]; then echo "/opt/gllb/nlb.sh" >> /etc/rc.local; fi
tail --lines=+2 /tmp/rc.local >> /etc/rc.local

echo "Installation completed. Please run 'gllb-run' to continue with configuration."

