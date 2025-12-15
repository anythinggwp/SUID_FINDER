# !/bin/sh
echo "Загружаем образ для chroot"
wget -O alpine-chroot.tar.gz https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-minirootfs-3.23.0-x86_64.tar.gz

echo "Распаковываем архив"
mkdir -p /mnt/chroot
tar -xzf alpine-chroot.tar.gz -C /mnt/chroot
# mkdir -p /mnt/chroot/{proc,sys,dev,dev/pts,dev/shm,tmp,usr,bin,sbin,etc,var}

echo "Копируем адреса DNS"
cp /etc/resolv.conf /mnt/chroot/etc/

echo "Создаем пользователя root"
echo "root:x:0:0:root:/root:/bin/sh" > /mnt/chroot/etc/passwd
echo "root::0:0:99999:7:::" > /mnt/chroot/etc/shadow
mkdir -p /mnt/chroot/root
./cmd/chroot_start.sh