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
	sudo ./cmd/chroot_deploy.sh

chroot-remove:
	sudo rm -rf /mnt/chroot
	sudo rm ./alpine-chroot.tar.gz