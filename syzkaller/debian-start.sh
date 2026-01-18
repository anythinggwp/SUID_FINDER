# !/bin/bash

virt-install \
  --name vm-debian \
  --memory 10240 \
  --vcpus 6 \
  --disk path=debian-virtual.qcow2,format=qcow2,bus=virtio \
  --os-variant debian12 \
  --network network=debian-net,model=virtio \
  --import