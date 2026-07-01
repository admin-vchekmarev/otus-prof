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
############ Устанавливаем fcgi
root@source:~# apt install spawn-fcgi php php-cgi php-cli \
 apache2 libapache2-mod-fcgid -y
############ Создаем fcgi.conf
root@source:~# cat > /etc/spawn-fcgi/fcgi.conf
# You must set some working options before the "spawn-fcgi" service will work.
# If SOCKET points to a file, then this file is cleaned up by the init script.
#
# See spawn-fcgi(1) for all possible options.
#
# Example :
SOCKET=/var/run/php-fcgi.sock
OPTIONS="-u www-data -g www-data -s $SOCKET -S -M 0600 -C 32 -F 1 -- /usr/bin/php-cgi"
root@source:~# cat > /etc/systemd/system/spawn-fcgi.service
[Unit]
Description=Spawn-fcgi startup service by Otus
After=network.target

[Service]
Type=simple
PIDFile=/var/run/spawn-fcgi.pid
EnvironmentFile=/etc/spawn-fcgi/fcgi.conf
ExecStart=/usr/bin/spawn-fcgi -n $OPTIONS
KillMode=process

[Install]
WantedBy=multi-user.target
root@source:~# systemctl start spawn-fcgi
root@source:~# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
     Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; preset: enabled)
     Active: active (running) since Wed 2026-07-01 20:17:31 UTC; 4s ago
   Main PID: 10963 (php-cgi)
      Tasks: 33 (limit: 4600)
     Memory: 14.6M (peak: 15.1M)
        CPU: 157ms
     CGroup: /system.slice/spawn-fcgi.service
             ├─10963 /usr/bin/php-cgi
             ├─10967 /usr/bin/php-cgi
             ├─10968 /usr/bin/php-cgi
             ├─10969 /usr/bin/php-cgi
             ├─10970 /usr/bin/php-cgi
             ├─10971 /usr/bin/php-cgi
             ├─10972 /usr/bin/php-cgi
             ├─10973 /usr/bin/php-cgi
             ├─10974 /usr/bin/php-cgi
             ├─10975 /usr/bin/php-cgi
             ├─10976 /usr/bin/php-cgi
             ├─10977 /usr/bin/php-cgi
             ├─10978 /usr/bin/php-cgi
             ├─10979 /usr/bin/php-cgi
             ├─10980 /usr/bin/php-cgi
             ├─10981 /usr/bin/php-cgi
             ├─10982 /usr/bin/php-cgi
             ├─10983 /usr/bin/php-cgi
             ├─10984 /usr/bin/php-cgi
             ├─10985 /usr/bin/php-cgi
             ├─10986 /usr/bin/php-cgi
             ├─10987 /usr/bin/php-cgi
             ├─10988 /usr/bin/php-cgi
             ├─10989 /usr/bin/php-cgi
             ├─10990 /usr/bin/php-cgi
             ├─10991 /usr/bin/php-cgi
             ├─10992 /usr/bin/php-cgi
             ├─10993 /usr/bin/php-cgi
             ├─10994 /usr/bin/php-cgi
             ├─10995 /usr/bin/php-cgi
             ├─10996 /usr/bin/php-cgi
             ├─10997 /usr/bin/php-cgi
             └─10998 /usr/bin/php-cgi

Jul 01 20:17:31 source systemd[1]: Started spawn-fcgi.service - Spawn-fcgi startup service by Otus.
################  Устанавливаем Nginx
root@source:~#  apt install nginx -y
root@source:~# systemctl start nginx@second
root@source:~# systemctl start nginx@first
root@source:~# ss -tnulp | grep nginx
tcp   LISTEN 0      511                  0.0.0.0:9001      0.0.0.0:*    users:(("nginx",pid=13576,fd=5),("nginx",pid=13575,fd=5),("nginx",pid=13574,fd=5),("nginx",pid=13572,fd=5),("nginx",pid=13571,fd=5))
tcp   LISTEN 0      511                  0.0.0.0:9002      0.0.0.0:*    users:(("nginx",pid=13861,fd=5),("nginx",pid=13860,fd=5),("nginx",pid=13859,fd=5),("nginx",pid=13858,fd=5),("nginx",pid=13857,fd=5))
tcp   LISTEN 0      511                  0.0.0.0:9011      0.0.0.0:*    users:(("nginx",pid=13910,fd=5),("nginx",pid=13909,fd=5),("nginx",pid=13908,fd=5),("nginx",pid=13907,fd=5),("nginx",pid=13906,fd=5))
tcp   LISTEN 0      511                  0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=13576,fd=6),("nginx",pid=13575,fd=6),("nginx",pid=13574,fd=6),("nginx",pid=13572,fd=6),("nginx",pid=13571,fd=6))
tcp   LISTEN 0      511                     [::]:80           [::]:*    users:(("nginx",pid=13576,fd=7),("nginx",pid=13575,fd=7),("nginx",pid=13574,fd=7),("nginx",pid=13572,fd=7),("nginx",pid=13571,fd=7))
root@source:~# ps afx | grep nginx
  11674 pts/1    T      0:00  |                       \_ journalctl -xeu nginx@first.service
  12114 pts/1    T      0:00  |                       \_ journalctl -xeu nginx.service
  12127 pts/1    T      0:00  |                       \_ journalctl -xeu nginx@first.service
  13588 pts/1    T      0:00  |                       \_ mc /etc/nginx/
  13704 pts/1    T      0:00  |                       \_ journalctl -xeu nginx@first.service
  13746 pts/1    T      0:00  |                       \_ journalctl -xeu nginx@first.service
  13839 pts/1    T      0:00  |                       \_ journalctl -xeu nginx@first.service
  13863 pts/1    T      0:00  |                       \_ journalctl -xeu nginx@first.service
  13915 pts/1    S+     0:00  |                       \_ grep --color=auto nginx
  13571 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -g daemon on; master_process on;
  13572 ?        S      0:00  \_ nginx: worker process
  13574 ?        S      0:00  \_ nginx: worker process
  13575 ?        S      0:00  \_ nginx: worker process
  13576 ?        S      0:00  \_ nginx: worker process
  13857 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on;
  13858 ?        S      0:00  \_ nginx: worker process
  13859 ?        S      0:00  \_ nginx: worker process
  13860 ?        S      0:00  \_ nginx: worker process
  13861 ?        S      0:00  \_ nginx: worker process
  13906 ?        Ss     0:00 nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on;
  13907 ?        S      0:00  \_ nginx: worker process
  13908 ?        S      0:00  \_ nginx: worker process
  13909 ?        S      0:00  \_ nginx: worker process
  13910 ?        S      0:00  \_ nginx: worker process
root@source:~# systemctl status nginx@second
● nginx@second.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/etc/systemd/system/nginx@.service; disabled; preset: enabled)
     Active: active (running) since Wed 2026-07-01 20:56:23 UTC; 1min 37s ago
       Docs: man:nginx(8)
    Process: 13850 ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-second.conf -q -g daemon on; master_process>
    Process: 13855 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_process on; (cod>
   Main PID: 13857 (nginx)
      Tasks: 5 (limit: 4600)
     Memory: 3.7M (peak: 4.5M)
        CPU: 98ms
     CGroup: /system.slice/system-nginx.slice/nginx@second.service
             ├─13857 "nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-second.conf -g daemon on; master_p>
             ├─13858 "nginx: worker process"
             ├─13859 "nginx: worker process"
             ├─13860 "nginx: worker process"
             └─13861 "nginx: worker process"

Jul 01 20:56:23 source systemd[1]: Starting nginx@second.service - A high performance web server and a reverse pro>
Jul 01 20:56:23 source systemd[1]: Started nginx@second.service - A high performance web server and a reverse prox>
lines 1-19/19 (END)
[10]+  Stopped                 systemctl status nginx@second
root@source:~# systemctl status nginx@first
● nginx@first.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/etc/systemd/system/nginx@.service; disabled; preset: enabled)
     Active: active (running) since Wed 2026-07-01 20:56:57 UTC; 1min 12s ago
       Docs: man:nginx(8)
    Process: 13903 ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-first.conf -q -g daemon on; master_process >
    Process: 13904 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on; (code>
   Main PID: 13906 (nginx)
      Tasks: 5 (limit: 4600)
     Memory: 3.7M (peak: 3.9M)
        CPU: 76ms
     CGroup: /system.slice/system-nginx.slice/nginx@first.service
             ├─13906 "nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_pr>
             ├─13907 "nginx: worker process"
             ├─13908 "nginx: worker process"
             ├─13909 "nginx: worker process"
             └─13910 "nginx: worker process"

Jul 01 20:56:57 source systemd[1]: Starting nginx@first.service - A high performance web server and a reverse prox>
Jul 01 20:56:57 source systemd[1]: Started nginx@first.service - A high performance web server and a reverse proxy>
lines 1-19/19 (END)
[11]+  Stopped                 systemctl status nginx@first
root@source:~#
