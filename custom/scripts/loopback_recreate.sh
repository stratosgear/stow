dd if=/dev/zero of=/raid0/loopback_images/primary bs=1024 count=40000
dd if=/dev/zero of=/raid0/loopback_images/2level_A bs=1024 count=45000
dd if=/dev/zero of=/raid0/loopback_images/2level_B bs=1024 count=45000
dd if=/dev/zero of=/raid0/loopback_images/2level_C bs=1024 count=45000
dd if=/dev/zero of=/raid0/loopback_images/mirror_A bs=1024 count=45000
dd if=/dev/zero of=/raid0/loopback_images/mirror_B bs=1024 count=45000
dd if=/dev/zero of=/raid0/loopback_images/mirror_C bs=1024 count=45000

sudo losetup /dev/loop0 /raid0/loopback_images/primary
sudo losetup /dev/loop1 /raid0/loopback_images/2level_A
sudo losetup /dev/loop2 /raid0/loopback_images/2level_B
sudo losetup /dev/loop3 /raid0/loopback_images/2level_C
sudo losetup /dev/loop4 /raid0/loopback_images/mirror_A
sudo losetup /dev/loop5 /raid0/loopback_images/mirror_B
sudo losetup /dev/loop6 /raid0/loopback_images/mirror_C

sudo mkfs.ext3 -m 1 -v /dev/loop0
sudo mkfs.ext3 -m 1 -v /dev/loop1
sudo mkfs.ext3 -m 1 -v /dev/loop2
sudo mkfs.ext3 -m 1 -v /dev/loop3
sudo mkfs.ext3 -m 1 -v /dev/loop4
sudo mkfs.ext3 -m 1 -v /dev/loop5
sudo mkfs.ext3 -m 1 -v /dev/loop6

sudo losetup -d /dev/loop0
sudo losetup -d /dev/loop1
sudo losetup -d /dev/loop2
sudo losetup -d /dev/loop3
sudo losetup -d /dev/loop4
sudo losetup -d /dev/loop5
sudo losetup -d /dev/loop6




