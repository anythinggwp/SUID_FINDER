#!/bin/sh
set -e

echo "Загружаем образ для chroot"
wget -O alpine-chroot.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.0-x86_64.tar.gz

echo "Распаковываем архив"
mkdir -p /mnt/chroot
tar -xzf alpine-chroot.tar.gz -C /mnt/chroot

echo "Копируем адреса DNS"
cp /etc/resolv.conf /mnt/chroot/etc/

# Создаём все необходимые директории до монтирования
mkdir -p /mnt/chroot/{proc,sys,dev/pts,dev/shm,tmp}

echo "Монтируем ядро хоста"
mount -t tmpfs tmpfs /mnt/chroot/dev         
mkdir -p /mnt/chroot/dev/pts                 
mount -t devpts devpts /mnt/chroot/dev/pts   
mount -t proc proc /mnt/chroot/proc
mount -t sysfs sysfs /mnt/chroot/sys -o ro,nosuid,nodev,noexec

# Создание символические устройства
mknod -m 666 /mnt/chroot/dev/null c 1 3
mknod -m 666 /mnt/chroot/dev/zero c 1 5
mknod -m 666 /mnt/chroot/dev/random c 1 8
mknod -m 666 /mnt/chroot/dev/urandom c 1 9

echo "Входим в chroot"
chroot /mnt/chroot /bin/sh

echo "Размонтирование ядра хоста после выхода"
umount /mnt/chroot/dev/pts
umount /mnt/chroot/dev
umount /mnt/chroot/sys
umount /mnt/chroot/proc