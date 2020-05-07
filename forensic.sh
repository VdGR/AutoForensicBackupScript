#!/bin/bash
# coment inserted by YP-PY
echo -e "stopping udisks2\n"
systemctl stop udisks2.service
echo -e "masking udisks2\n"
systemctl mask udisks2.service

read -n 1 -s -r -p "Attach drive to machine, press any key when done....\n"
echo -e "scsi host scan\n"
echo "- - -" > /sys/class/scsi_host/host0/scan
echo "- - -" > /sys/class/scsi_host/host1/scan
echo "- - -" > /sys/class/scsi_host/host2/scan


MD5=$(md5sum  /dev/sdb)
echo -e "MD5, "${MD5}"\n"

echo -e"making copy of disk \n"
dd if=/dev/sdb of=sdb-backup.img status=progress


MD5_of_copy=$(md5sum sdb-backup.img)
echo -e"MD5_of_copy, "${MD5_of_copy}"\n"

echo -e"removing disk\n"
echo 1 > /sys/block/sdb/device/delete

echo -e "unmask of udisk2.service\n"
systemctl unmask udisks2.service
echo -e "starting udisk2.service\n"
systemctl start udisks2.service


echo -e "creating loopback device of copy\n"
losetup -fPr sdb-backup.img --show

