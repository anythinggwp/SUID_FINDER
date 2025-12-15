# !/bin/sh
echo "Загружаем образ для virtualbox"
wget -O alpine-virtualbox.iso https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-standard-3.23.0-x86_64.iso

echo "Создаем tap интерфейс"
ip tuntap add dev tap0 mode tap
ip link set tap0 master br0
ip link set tap0 up

echo "Создаем образ диска для VM"


echo "Запускаем VM"
