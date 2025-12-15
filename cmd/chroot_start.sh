# !/bin/sh
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