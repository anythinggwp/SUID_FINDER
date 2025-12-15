#!/bin/sh
echo "Загружаем образ для chroot"
wget -O alpine-chroot.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.0-x86_64.tar.gz

echo "Распаковываем архив"
mkdir -p /mnt/chroot
tar -xzf alpine-chroot.tar.gz -C /mnt/chroot
# mkdir -p /mnt/chroot/{proc,sys,dev,dev/pts,dev/shm,tmp,usr,bin,sbin,etc,var}

echo "Копируем адреса DNS"
cp /etc/resolv.conf /mnt/chroot/etc/

echo "Монтируем ядро хоста"
mount -t proc proc /mnt/chroot/proc

mount --rbind /sys /mnt/chroot/sys
mount --make-rslave /mnt/chroot/sys

mount --rbind /dev /mnt/chroot/dev
mount --make-rslave /mnt/chroot/dev

mount -t devpts devpts /mnt/chroot/dev/pts

chroot /mnt/chroot /bin/sh

echo "Размонтирование ядра хоста"
umount -l /mnt/chroot/proc
umount -l /mnt/chroot/dev/pts
umount -l /mnt/chroot/sys
umount -l /mnt/chroot/dev