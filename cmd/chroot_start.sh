# !/bin/sh
echo "Монтируем ядро хоста"
mount -t proc proc /mnt/chroot/proc

mount --rbind /sys /mnt/chroot/sys
mount --make-rslave /mnt/chroot/sys

mount --rbind /dev /mnt/chroot/dev
mount --make-rslave /mnt/chroot/dev

mount -t devpts devpts /mnt/chroot/dev/pts

chroot /mnt/chroot /bin/sh

echo "Размонтирование ядра хоста"

umount /mnt/chroot/proc
umount /mnt/chroot/dev/pts
umount /mnt/chroot/sys
umount /mnt/chroot/dev