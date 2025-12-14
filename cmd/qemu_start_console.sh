# !/bin/sh
echo "Запускаем VM"

qemu-system-x86_64 -m 2048 -smp 2 -netdev tap,id=n1,ifname=tap0,script=no,downscript=no -device virtio-net,netdev=n1 -nographic alpine-virtula-test.qcow2
