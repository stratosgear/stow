sudo umount /mnt/primary
sudo umount /mnt/2level_A
sudo umount /mnt/2level_B
sudo umount /mnt/mirror_A
sudo umount /mnt/mirror_B

sudo losetup -d /dev/loop0
sudo losetup -d /dev/loop1
sudo losetup -d /dev/loop2
sudo losetup -d /dev/loop3
sudo losetup -d /dev/loop4



