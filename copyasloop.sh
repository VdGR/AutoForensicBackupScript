#!/bin/bash
# coment inserted by YP-PY
echo -e "Stopping udisks2"
systemctl stop udisks2.service
echo -e "Masking udisks2"
systemctl mask udisks2.service

read=$(echo -e "\e[1;5mAttach drive to machine, press any key when done....\e[24m\e[0m")
read -n 1 -s -r -p "${read}"

echo 
echo -e "Scsi host scan\n"
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan


MD5=$(md5sum /dev/sdb)
echo -e "MD5, \e[1;92m"${MD5}"\e[0m\n"

echo -e "Making copy of disk"
dd if=/dev/sdb of=sdb-backup.img status=progress

echo
MD5_of_copy=$(md5sum sdb-backup.img)
echo -e "MD5_of_copy, \e[1;92m"${MD5_of_copy}"\e[0m\n"

echo -e "Removing disk"
echo 1 > /sys/block/sdb/device/delete

echo -e "Unmask of udisk2.service"
systemctl unmask udisks2.service
echo -e "Starting udisk2.service\n"
systemctl start udisks2.service


echo -e "Creating loopback device of copy"
losetup -fPr sdb-backup.img --show

echo -e "\e[1;92mDone! \e[0m"
