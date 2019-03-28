############################################
# Generic Linux Load Balancer
# by : steelburn
# @  : steelburn(at)blogspaper(dot)org
############################################

REQUIREMENTS
-----------
1. 	Basic Debian installation. Please use Network install CD (http://www.debian.org/CD/netinst/) for smaller footprint. Other distro is not supported.
	The most you need is just 'SSH Server' package so that you can SCP the GLLB package.
2.	Minimum 1GB hard disk space. Recommended: 10GB.
3.	Minimum 512MB RAM. Recommended: At least 1GB.

## QUICK: HOW TO INSTALL
--------------
Run this in terminal: ``wget https://raw.githubusercontent.com/steelburn/gllb-load-balancer/master/install.sh -O install.sh && PWD=$PWD bash ./install.sh``


## LONGER: HOW TO INSTALL
--------------
1. Copy GLLB package into the server. 
2. Unpack the package.
3. Go into package directory.
4. Execute: chmod +x install-nlb.sh
5. Execute: ./install-nlb.sh
6. Execute: gllb-run
7. Configure load balancer from the menu. Remember to 'Apply Changes' in each section.
8. Reboot.
9. Once rebooted, login and verify by choosing 'Check Status'. If it is empty, something is wrong. Redo configuration.
10. Done. Verify external access. Then leave the system alone. 


