############ создали файл в etc/default
s@source:~$ sudo -i
[sudo] password for vs:
root@source:~# cat /etc/default/watchlog
cat: /etc/default/watchlog: No such file or directory
root@source:~# cat > /etc/default/watchlog
# Configuration file for my watchlog service
# Place it to /etc/default

# File and word in that file that we will be monit
WORD="ALERT"
LOG=/var/log/watchlog.log

########### созадли файл лога в var/log
root@source:~# cat >  /var/log/watchlog.log
asdsadasd
asdsada
asad
ALERT
safrgdfg
1111111111111
ALERT

asdsad
asdasda
ALERT
########### скрипт в opt
root@source:~# cat > /opt/watchlog.sh
#!/bin/bash

WORD=$1
LOG=$2
DATE=`date`

if grep $WORD $LOG &> /dev/null
then
logger "$DATE: I found word, Master!"
else
exit 0
fi
root@source:~# chmod +x /opt/watchlog.sh
###############   Create service
root@source:~# cat > /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/default/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG
##############  Create timer
root@source:~# cat > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service
root@source:~# systemctl start watchlog.service
root@source:~# systemctl start watchlog.timer
root@source:~# tail -n 1000 /var/log/syslog  | grep word
2026-07-01T19:37:37.287333+00:00 source systemd[1]: Started systemd-ask-password-console.path - Dispatch Password Requests to Console Directory Watch.
2026-07-01T19:37:37.287397+00:00 source systemd[1]: systemd-ask-password-plymouth.path - Forward Password Requests to Plymouth Directory Watch was skipped because of an unmet condition check (ConditionPathExists=/run/plymouth/pid).
2026-07-01T19:37:37.313678+00:00 source kernel: systemd[1]: Started systemd-ask-password-wall.path - Forward Password Requests to Wall Directory Watch.
2026-07-01T19:37:37.314384+00:00 source kernel: audit: type=1400 audit(1782934654.883:2): apparmor="STATUS" operation="profile_load" profile="unconfined" name="1password" pid=592 comm="apparmor_parser"
2026-07-01T19:44:50.281773+00:00 source root: Wed Jul  1 07:44:50 PM UTC 2026: I found word, Master!








<img width="458" height="187" alt="image" src="https://github.com/user-attachments/assets/910a3e69-cfb5-4299-a439-c2d6d49cdbfa" />
root@source:~# cat > /etc/systemd/system/watchlog.service
[Unit]
Description=My watchlog service

[Service]
Type=oneshot
EnvironmentFile=/etc/default/watchlog
ExecStart=/opt/watchlog.sh $WORD $LOG

root@source:~# cat > /etc/systemd/system/watchlog.timer
[Unit]
Description=Run watchlog script every 30 second

[Timer]
# Run every 30 second
OnUnitActiveSec=30
Unit=watchlog.service

[Install]
WantedBy=multi-user.target
root@source:~#
