# !/bin/sh
echo "Загружаем образ для chroot"
wget -O alpine-chroot.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.0-x86_64.tar.gz

echo "Распаковываем архив"
mkdir -p /mnt/chroot
tar -xzf alpine-chroot.tar.gz -C /mnt/chroot
mkdir -p /mnt/chroot/{proc,sys,dev,dev/pts,dev/shm,tmp,usr,bin,sbin,etc,var}

echo "Монтируем ядро хоста"
mount -t proc proc /mnt/chroot/proc
mount --rbind /sys /mnt/chroot/sys
mount --rbind /dev /mnt/chroot/dev

chroot /mnt/chroot /bin/sh --login

echo "Размонтирование ядра хоста"
umount -l /mnt/chroot/proc
umount -R -l /mnt/chroot/sys
umount -R -l /mnt/chroot/dev