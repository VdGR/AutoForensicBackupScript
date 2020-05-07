#!/bin/bash


partions_loop=$(lsblk | grep loop0p | wc -l)

backup_file=sdb-backup.img
if test -f "$backup_file"; then
    rm -rvf $backup_file 
fi

lsblk
echo

for (( c=1; c <=${partions_loop}; c++ ))
do  
	echo -e "unmounting /dev/loop0p$c"
    umount -f -l /dev/loop0p$c
	echo 

done

echo -e "unmounting loop device"
losetup -d  /dev/loop0

lsblk

