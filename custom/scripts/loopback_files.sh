#!/usr/bin/sh


dd if=/dev/zero of=disk1 bs=1024 count=65536 # size is 64MB

losetup -f		  	# first available free loopback device

losetup /dev/loop0 disk1  	# attach device

mkfs.ext3 -m 1 -v /dev/loop0	# make partition

mkdir /mnt/loop0  		# make dir

mount -t ext3 /dev/loop0 /mnt/loop0	# mount file
