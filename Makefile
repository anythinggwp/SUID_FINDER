create-bridge:

	sudo ip link add br0 type bridge
	sudo ip link set br0 up 
	sudo ip link set enp1s0 down
	sudo ip link set enp1s0 master br0
	sudo ip addr flush dev enp1s0
	sudo ip addr add 192.168.100.202/24 dev br0
	sudo ip route add default via 192.168.100.1