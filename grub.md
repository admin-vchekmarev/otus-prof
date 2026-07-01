<img width="775" height="133" alt="image" src="https://github.com/user-attachments/assets/22a777af-e02f-46b9-abc0-2c2b1c9b122d" />vs@source:~$ sudo nano /etc/default/grub
[sudo] password for vs:
#################### Устанавливаем задержку GRUB
GRUB_DEFAULT=0
#GRUB_TIMEOUT_STYLE=hidden
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`( . /etc/os-release; echo ${NAME:-Ubuntu} ) 2>/dev/null || echo Ubuntu`
GRUB_CMDLINE_LINUX_DEFAULT=""
GRUB_CMDLINE_LINUX=""
<img width="775" height="133" alt="image" src="https://github.com/user-attachments/assets/50193432-ca1b-4b54-b9a0-65b70f5518e3" />
############### Grub
<img width="815" height="652" alt="image" src="https://github.com/user-attachments/assets/4f7a81c8-ce85-4562-b48e-7b14d0ccae37" />
################ Пробуем попасть без пароля, нажимаем e при выборе загрузки
<img width="747" height="630" alt="image" src="https://github.com/user-attachments/assets/b7863c56-4268-4937-890d-6da0c3a0982d" />
############ добавляем строку 
<img width="664" height="565" alt="image" src="https://github.com/user-attachments/assets/1f590e82-fbdd-4eb8-bfa2-1ab43b08fa81" />
############ Попали в систему
<img width="759" height="438" alt="image" src="https://github.com/user-attachments/assets/cf587580-73aa-44c0-a907-f8611e85772a" />
############ Перемонтировали и создали файл в root
<img width="755" height="430" alt="image" src="https://github.com/user-attachments/assets/1db936d8-c823-4065-8ae8-48605fa62f91" />
################## Через recowery mode
<img width="647" height="559" alt="image" src="https://github.com/user-attachments/assets/48331f47-b045-427c-b557-75c1fbbfe2a5" />

<img width="749" height="512" alt="image" src="https://github.com/user-attachments/assets/738fded5-754f-4b26-aba6-3fa16ec50e24" />

<img width="735" height="644" alt="image" src="https://github.com/user-attachments/assets/7f38209a-a3d7-41a6-bc54-537f36e8788d" />
#############  Переименование VG
vs@source:~$ vgs
  WARNING: Running as a non-root user. Functionality may be unavailable.
  /run/lock/lvm/P_global:aux: open failed: Permission denied
vs@source:~$ sudo vgs
[sudo] password for vs:
  VG        #PV #LV #SN Attr   VSize  VFree
  ubuntu-vg   1   1   0 wz--n- <8.25g    0
vs@source:~$ sudo vgrename ubuntu-vg ubuntu-otus
  Volume group "ubuntu-vg" successfully renamed to "ubuntu-otus"
vs@source:~$ sudo nano  /boot/grub/grub.cfg
vs@source:~$ sudo mc  /boot/grub/grub.cfg

Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.basic
  3. /usr/bin/mcedit
  4. /usr/bin/vim.tiny
  5. /bin/ed

Choose 1-5 [1]: 3


vs@source:~$ sudo reboot
vs@source:~$ sudo vgs
[sudo] password for vs:
  VG          #PV #LV #SN Attr   VSize  VFree
  ubuntu-otus   1   1   0 wz--n- <8.25g    0
vs@source:~$
############ переименовался
