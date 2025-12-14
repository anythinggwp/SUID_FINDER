# !/bin/sh
echo "Загружаем образ для chroot"
wget -O alpine-chroot.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.0-x86_64.tar.gz

echo "Распаковываем архив"
mkdir -p /mnt/chroot
tar -xzf alpine-chroot.tar.gz -C /mnt/chroot

mount -t proc proc /mnt/chroot/proc
mount --rbind /sys /mnt/chroot/sys
mount --rbind /dev /mnt/chroot/dev

chroot /mnt/chroot /bin/sh

umount -R /mnt/chroot/dev
umount -R /mnt/chroot/sys
umount /mnt/chroot/proc