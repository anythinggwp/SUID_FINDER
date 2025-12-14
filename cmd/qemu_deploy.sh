# !/bin/sh
IMAGE_PATH=$1

echo $IMAGE_PATH

wget -O alpine-virtual.iso https://dl-cdn.alpinelinux.org/alpine/v3.23/releases/x86_64/alpine-virt-3.23.0-x86_64.iso

qemu-img create -f qcow2 alpine-test.qcow2 10G

qemu-system-x86_64 -m 2048 -netdev user,id=n1,hostfwd=tcp::2222-:22 -device virtio-net,netdev=n1  -cdrom alpine-virtual.iso -nographic alpine-test.qcow2

qemu-system-x86_64 -m 2048 -netdev tap,id=n1,ifname=tap0,script=no,downscript=no -device virtio-net,netdev=n1  -nographic alpine-test.qcow2