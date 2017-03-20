sudo losetup /dev/loop0 /raid0/loopback_images/primary
sudo losetup /dev/loop1 /raid0/loopback_images/2level_A
sudo losetup /dev/loop2 /raid0/loopback_images/2level_B
sudo losetup /dev/loop3 /raid0/loopback_images/2level_C
sudo losetup /dev/loop4 /raid0/loopback_images/mirror_A
sudo losetup /dev/loop5 /raid0/loopback_images/mirror_B
sudo losetup /dev/loop6 /raid0/loopback_images/mirror_C

sudo mount -t ext3 /dev/loop0 /mnt/primary
sudo mount -t ext3 /dev/loop1 /mnt/2level_A
sudo mount -t ext3 /dev/loop2 /mnt/2level_B
sudo mount -t ext3 /dev/loop3 /mnt/2level_C
sudo mount -t ext3 /dev/loop4 /mnt/mirror_A
sudo mount -t ext3 /dev/loop5 /mnt/mirror_B
sudo mount -t ext3 /dev/loop6 /mnt/mirror_C

sudo chown stratos:stratos /mnt/*


