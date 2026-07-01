#!/bin/bash
echo "###########################################################################"
echo "##############            Настраиаем сервер           #####################"
echo "###########################################################################"
sudo apt install nfs-kernel-server
mkdir -p /srv/share/upload
chown -R nobody:nogroup /srv/share
chmod 0777 /srv/share/upload

cat << EOF > /etc/exports
/srv/share 192.168.56.104/32(rw,sync,root_squash)
EOF
exportfs -r
echo "Для продолжения нажмите Enter"
exportfs -s
echo "Для продолжения нажмите Enter"

echo "###########################################################################"
echo "##############            Создаем файл                #####################"
echo "###########################################################################"
cd /srv/share/upload/
touch test_file_1
touch test_file_2
touch test_file_3
ls
echo "Для продолжения нажмите Enter"
