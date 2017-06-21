#!/bin/bash
echo ================================================
echo DATE : $(date)
echo HOST: $(hostname)
IPADDR=$(/sbin/ifconfig | sed -n '2 p' | awk '{print $2}')
echo IP  $IPADDR
echo UPTIME : $(/usr/bin/uptime)
echo ================================================

echo +++++++++++ PROCESS +++++++++++
echo ================================================
echo Open Files:
echo ------------------------------------------------
/usr/sbin/lsof -l
echo ================================================

echo ================================================
echo Active Processes:
echo ------------------------------------------------
/bin/ps aux
echo ================================================

echo ================================================
echo Process Tree
echo ------------------------------------------------
/usr/bin/pstree -AluZ
echo ================================================

echo +++++++++++ USERS +++++++++++
echo ================================================
echo Logged on users:
echo ------------------------------------------------
/usr/bin/users
echo ================================================
 
echo ================================================
echo Accounts with null passwords:
echo ------------------------------------------------
awk -F: '($2 == "") {print $1}' /etc/shadow
echo ================================================

echo ================================================
echo Last 10 created users:
echo ------------------------------------------------
sort -nk3 -t: /etc/passwd | tail  -n10
echo ================================================

echo ================================================
echo Duplicate UIDs:
echo ------------------------------------------------
cut -f3 -d: /etc/passwd | sort -n | uniq -c | awk '!/ 1 / {print $2 }'
echo ================================================

echo ================================================
echo Accounts with GID == 0:
echo ------------------------------------------------
egrep ':0+:' /etc/passwd
echo ================================================

echo ================================================
echo  Accounts with UID == 0:
echo ------------------------------------------------
awk -F: '($3 == 0) {print $1}' /etc/passwd
echo ================================================

echo ================================================
echo Failed Logins
echo ------------------------------------------------
grep -i fail /var/log/auth.log
echo ================================================
echo +++++++++++ FILESYSTEM +++++++++++

echo +++++++++++ NETWORK +++++++++++
echo ================================================
echo ARP Cache:
echo ------------------------------------------------
arp -a
echo ================================================

echo ================================================
echo Default Route:
echo ------------------------------------------------
netstat -r
echo ================================================

echo ================================================
echo Listening Connection
echo ------------------------------------------------
netstat -vnpl
echo ================================================