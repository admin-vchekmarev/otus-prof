#!/bin/bash
sudo apt install nfs-common
echo "192.168.56.103:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab
systemctl daemon-reload 
systemctl restart remote-fs.target 
cd /mnt/
mount | grep mnt
ls
cd /mnt/upload
ls
