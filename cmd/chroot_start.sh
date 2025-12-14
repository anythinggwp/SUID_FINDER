# !/bin/sh
echo "Монтируем ядро хоста"
mount -t proc proc /mnt/chroot/proc
mount --rbind /sys /mnt/chroot/sys
mount --rbind /dev /mnt/chroot/dev

chroot /mnt/chroot /bin/sh --login

echo "Размонтирование ядра хоста"
umount -l /mnt/chroot/proc
umount -R -l /mnt/chroot/sys
umount -R -l /mnt/chroot/dev