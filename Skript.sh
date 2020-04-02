
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


+-------------------------------------------+
|            Interfaces ROUTER 1            |
+-------------------------------------------+
|eth0:OK |eth1:OK |eth2:OK |eth3:OK |eth4:- |
+-------------------------------------------+
|            Interfaces ROUTER 2            |
+-------------------------------------------+
|eth0:OK |eth1:OK |eth2:OK |eth3:OK |eth4:- |
+-------------------------------------------+
|           DHCP SERVER - ROUTER 1          |
+-------------------------------------------+
|        eth1:OK       |        eth2:OK     |
+-------------------------------------------+
|           DHCP SERVER - ROUTER 2          |
+-------------------------------------------+
|        eth1:OK       |        eth2:OK     |
+-------------------------------------------+
|                TFTP SERVER                |
+-------------------------------------------+
|     Router2:NOK      |     Router1:OK     |
+-------------------------------------------+
|            Statische Route R1             |
+-------------------------------------------+
|       Route zu 192.168.0.0/24: OK         |
|       Route zu 192.168.1.2: OK            |
+-------------------------------------------+
|            Statische Route R2             |
+-------------------------------------------+
|         Route zu 10.0.0.0/24: OK          |
|         Route zu 10.0.1.0: OK             |
+-------------------------------------------+
|          Firewall: Ping Local             |
+-------------------------------------------+
|                eth3:OK                    |
+-------------------------------------------+
|          Firewall: Ping LAN               |
+-------------------------------------------+
|          Ping an 192.168.0.2:OK           |
+-------------------------------------------+
|          Firewall: HTTP                   |
+-------------------------------------------+
|                 HTTP:OK                   |
+-------------------------------------------+
|          Firewall: Ping Related           |
+-------------------------------------------+
|                 Related:OK                |
+-------------------------------------------+

