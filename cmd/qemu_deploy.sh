# !/bin/sh
echo "Загружаем образ для qemu"
wget -O alpine-virtual.iso https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-virt-3.23.0-x86_64.iso

echo "Создаем tap интерфейс"
ip tuntap add dev tap0 mode tap
ip link set tap0 master br0
ip link set tap0 up

echo "Создаем образ диска для VM"
qemu-img create -f qcow2 alpine-virtula-test.qcow2 10G

echo "Запускаем VM"
qemu-system-x86_64 -m 2048 -smp 2 -netdev tap,id=n1,ifname=tap0,script=no,downscript=no -device virtio-net,netdev=n1  -cdrom alpine-virtual.iso -nographic alpine-virtula-test.qcow2