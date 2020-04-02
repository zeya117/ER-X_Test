#!/bin/bash

bold=$(tput bold)
normal=$(tput sgr0)

######Jeweilige Directories loeschen/erstellen######

rm -r /home/$USER/Documents/Test
mkdir /home/$USER/Documents/Test
cd /home/$USER/Documents/Test

######i ist jeweiliges Studentengruppe#####

i=0

#while true
#do 

######Ueberpruefung der Interface Adressen######
######ueber sshpass bzw ssh werden die jeweiligen Outputs von show Befehlen in einer txt Datei gespeichert#####
sshpass -p ubnt ssh -q ubnt@192.168.1.1 "vbash -ic 'show interfaces'" > interfaces1.txt
sshpass -p ubnt ssh -q ubnt@192.168.0.1 "vbash -ic 'show interfaces'" > interfaces2.txt 

sshpass -p ubnt ssh -q ubnt@192.168.1.1 "vbash -ic 'show configuration'" > configuration1.txt
sshpass -p ubnt ssh -q ubnt@192.168.0.1 "vbash -ic 'show configuration'" > configuration2.txt

sshpass -p ubnt ssh -q ubnt@192.168.1.1 "sudo ping -w2 192.168.2.1" > Firewall1_eth3.txt
sshpass -p ubnt ssh -q ubnt@192.168.1.1 "sudo ping -w2 192.168.0.2" > Firewall2_ping.txt
sshpass -p ubnt ssh -q ubnt@192.168.1.1 "curl -s -m 5 --head --request GET http://192.168.0.2:81" > Firewall3_http.txt 


echo "+-------------------------------------------+"

echo "|           ${bold} Interfaces ROUTER 1 ${normal}           |"
#Router 1 - eth0#

echo "+-------------------------------------------+"

if grep "eth0" interfaces1.txt | grep -q "172.31.0.1"; then

echo -n "|eth0:OK |"

else

echo -n "|eth0:NOK|"

fi      

#Router 1 - eth1#

if grep "eth1" interfaces1.txt | grep -q "10.0.0.1/24"; then

echo -n "eth1:OK |"

else

echo -n "eth1:NOK|"

fi

#Router 1 - eth2#

if grep "eth2" interfaces1.txt | grep -q "10.0.1.1/24"; then

echo -n "eth2:OK |"

else

echo -n "eth2:NOK|"

fi

#Router 1 - eth3" 

if grep "eth3" interfaces1.txt | grep -q "192.168.1.1/30"; then

echo -n "eth3:OK |"

else

echo -n "eth3:NOK|"

fi

echo "eth4:- |"
echo "+-------------------------------------------+"
echo "|           ${bold} Interfaces ROUTER 2  ${normal}          |"
echo "+-------------------------------------------+"


#Router 2 - eth0#


if grep "eth0" interfaces2.txt | grep -q "172.31.0.2/24"; then 

echo -n "|eth0:OK |"

else

echo -n "|eth0:NOK|"

fi

#Router 2 - eth1#

if grep "eth1" interfaces2.txt | grep -q "192.168.0.1/24"; then

echo -n "eth1:OK |"

else

echo -n "eth1:NOK|"

fi

#Router 2 - eth2#

if grep "eth2" interfaces2.txt | grep -q "192.168.2.1/24"; then

echo -n "eth2:OK |"

else

echo -n "eth2:NOK|"

fi

#Router 2 - eth3" 

if grep "eth3" interfaces2.txt | grep -q "192.168.1.2/30"; then

echo -n "eth3:OK |"

else

echo -n "eth3:NOK|"

fi

echo "eth4:- |"

#done

######Ueberpruefung der DHCP Server######
echo "+-------------------------------------------+"
echo "|          ${bold} DHCP SERVER - ROUTER 1 ${normal}         |"
echo "+-------------------------------------------+"


if grep -A1 "subnet 10.0.0.0/24" configuration1.txt | grep -q "10.0.0.1"; then

echo -n "|        eth1:OK       |"

else

echo -n "|        eth1:NOK      |"

fi

if grep -A1 "subnet 10.0.1.0/24" configuration1.txt | grep -q "10.0.1.1"; then

echo "        eth2:OK     |"

else

echo "        eth2:NOK    |"

fi

echo "+-------------------------------------------+"
echo "|           ${bold}DHCP SERVER - ROUTER 2${normal}          |"
echo "+-------------------------------------------+"


if grep -A1 "subnet 192.168.0.0/24" configuration2.txt | grep -q "192.168.0.1"; then

echo -n "|        eth1:OK       |"

else

echo -n "|        eth1:NOK      |"

fi

if grep -A1 "subnet 192.168.2.0/24" configuration2.txt | grep -q "192.168.2.1"; then

echo "        eth2:OK     |"

else

echo "        eth2:NOK    |"

fi


#####Ueberpruefung der TFTP Einstellungen#####
####Router 1####
echo "+-------------------------------------------+"
echo "|               ${bold} TFTP SERVER ${normal}               |"
echo "+-------------------------------------------+"
if grep -A2 "location tftp://192.168.0.2" configuration1.txt | grep -q "commit-revisions 10"; then

echo -n "|     Router1:OK       |"

else

echo -n "|     Router2:NOK      |"

fi
####Router 2####
if grep -A2 "location tftp://192.168.0.2" configuration2.txt | grep -q "commit-revisions 10"; then

echo  "     Router1:OK     |"

else

echo  "     Router2:NOK    |"

fi


#####Ueberpruefung der statischen Routen#####
####Router 1####

##Zu 192.168.0.0/24##
echo "+-------------------------------------------+"
echo "|            ${bold}Statische Route R1${normal}             |"
echo "+-------------------------------------------+"
if grep -A1 "route 192.168.0.0/24" configuration1.txt | grep -q "next-hop 192.168.1.2"; then

echo "|       Route zu 192.168.0.0/24: OK         |"

else

echo "|       Route zu 192.168.0.0/24: NOK        |"

fi 
##Zu 192.168.1.2/24##
if grep -A1 "route 192.168.2.0/24" configuration1.txt | grep -q "next-hop 192.168.1.2"; then

echo "|       Route zu 192.168.1.2: OK            |"

else

echo "|       Route zu 192.168.1.2: NOK           |"

fi

####Router 2#####
##Zu 10.0.0.0/24##
echo "+-------------------------------------------+"
echo "|            ${bold}Statische Route R2${normal}             |"
echo "+-------------------------------------------+"
if grep -A1 "route 10.0.0.0/24" configuration2.txt | grep -q "next-hop 192.168.1.1"; then

echo "|         Route zu 10.0.0.0/24: OK          |"

else

echo "|         Route zu 10.0.0.0/24: NOK         |"

fi
##Zu 192.168.1.2/24##
if grep -A1 "route 10.0.1.0/24" configuration2.txt | grep -q "next-hop 192.168.1.1"; then

echo "|         Route zu 10.0.1.0: OK             |"

else

echo "|         Route zu 10.0.1.0: NOK            |"

fi

#######Firewallregeln#######
#####Aufgabe1 Ping Local####

####Pings an die Interfaces von Router 2 testen####
echo "+-------------------------------------------+"
echo "|          ${bold}Firewall: Ping Local${normal}             |"
echo "+-------------------------------------------+"

if grep -A1 "ttl=64 bytes from" Firewall1_eth3.txt | grep -q "time="; then

echo "|                eth3:NOK                   |"

else

echo "|                eth3:OK                    |"

fi

#####Aufgabe2 Ping LAN from PC1####

####Ping an File-Server testen & Establishe/Related via config
echo "+-------------------------------------------+"
echo "|          ${bold}Firewall: Ping LAN  ${normal}             |"
echo "+-------------------------------------------+"

if grep -A1 "ttl=64 bytes from" Firewall2_ping.txt | grep -q "time="; then

echo "|          Ping an 192.168.0.2:NOK          |"

else

echo "|          Ping an 192.168.0.2:OK           |"

fi

####Aufgabe 3 HTTP erreichbar ja, nein####
echo "+-------------------------------------------+"
echo "|          ${bold}Firewall: HTTP      ${normal}             |"
echo "+-------------------------------------------+"


if grep -q "200 OK" Firewall3_http.txt; then

echo "|                 HTTP:NOK                  |"

else

echo "|                 HTTP:OK                   |"

fi


echo "+-------------------------------------------+"
echo "|          ${bold}Firewall: Ping Related ${normal}          |"
echo "+-------------------------------------------+"
if grep -A10 "default-action accept" configuration2.txt | grep -A7  "action accept" | grep -q "related enable"; then

echo "|                 Related:OK                |"

else

echo "|                 Related:NOK               |"

fi

######Resetten der Geraete#####
#sshpass -p ubnt ssh ubnt@192.168.1.1 "vbash -ic 'set-default'" 
#sshpass -p ubnt ssh ubnt@192.168.0.1 "vbash -ic 'set-default'" 
#oder
#sshpass -p ubnt ssh ubnt@192.168.1.1 "vbash -ic 'syswrapper.sh restore-default'"
#sshpass -p ubnt ssh ubnt@192.168.0.1 "vbash -ic 'syswrapper.sh restore-default'"



