# !/bin/sh
echo "Создаем tap интерфейс"
ip tuntap add dev tap0 mode tap
ip link set tap0 master br0
ip link set tap0 up

echo "Создаем образ диска для VM"
qemu-img create -f qcow2 astra-db.qcow2 10G

echo "Запускаем VM"
qemu-system-x86_64 -m 2048 \
    -smp 2 \
    -netdev tap,id=n1,ifname=tap0,script=no,downscript=no \
    -device virtio-net,netdev=n1 \
    -cdrom /dev/sr0 \
    -device virtio-vga \
    -spice port=5930,disable-ticketing=on \
    astra-db.qcow2