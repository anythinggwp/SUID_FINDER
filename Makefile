create-bridge:
	sudo ./cmd/create_bridge.sh

qemu-deploy:
	sudo ./cmd/qemu_deploy.sh

qemu-start-console:
	sudo ./cmd/qemu_start_console.sh

qemu-start-spice:
	sudo ./cmd/qemu_start_spice.sh

chroot-deploy:
	sudo ./cmd/chroot_deploy.sh

chroot-start:
	sudo ./cmd/chroot_start.sh

chroot-remove:
	sudo rm -rf /mnt/chroot
	sudo rm ./alpine-chroot.tar.gz

virtualbox-deploy:
	sudo ./cmd/virtualbox_deploy.sh

virtualbox-start:
	VBoxManage startvm "alpineVM"

virtualbox-remove:
	rm -rf ~/VirtualBox VMs/alpineVM

build-gcc-host-prepare:
	./cmd/build_gcc_host_pre.sh

build-gcc-host-remove:
	sudo rm -rf /tmp/gcc-tmp-tty1/*
	sudo rm -rf /tmp/gcc-tmp-tty2/*
	sudo rm -rf /tmp/gcc-tmp-tty3/*

build-gcc-host-start:
	./cmd/build_gcc_host_start.sh

build-gcc-lxc-pre:
	./cmd/build_gcc_lxc_pre.sh

build-gcc-lxc-start:
	./cmd/build_gcc_lxc_start.sh

build-gcc-lxc-remove:
	sudo lxc-destroy -n cont-1
	sudo lxc-destroy -n cont-2
	sudo lxc-destroy -n cont-3
tar-simply:
	tar -czf simply.tar.gz ./simply_http_server