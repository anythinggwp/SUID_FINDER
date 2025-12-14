create-bridge:
	sudo ip link add br0 type bridge
	sudo ip link set br0 up 
	sudo ip link set enp1s0 down
	sudo ip link set enp1s0 master br0

	@while ! bridge link | grep -q "enp1s0.*master br0"; do sleep 0.1; done
	
	sudo ip addr flush dev enp1s0
	sudo ip addr add 192.168.100.202/24 dev br0
	sudo ip route add default via 192.168.100.1
	sudo ip link set enp1s0 up
	echo -e "nameserver 192.168.100.1\nnameserver 8.8.8.8" | sudo tee /etc/resolv.conf