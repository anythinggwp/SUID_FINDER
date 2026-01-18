# !/bin/bash

echo "Загружаем образ для qemu"
wget --no-clobber -O debian-virtual.qcow2 https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-nocloud-amd64.qcow2

echo "Создаем сеть"
virsh net-define debian-net.xml
virsh net-start debian-net
virsh net-autostart debian-net

virt-install \
  --name vm-debian \
  --memory 10240 \
  --vcpus 6 \
  --disk path=debian-virtual.qcow2,format=qcow2,bus=virtio \
  --os-variant debian12 \
  --network network=debian-net,model=virtio \
  --graphics spice,listen=127.0.0.1 \
  --video qxl \
  --import \
  --channel spicevmc
