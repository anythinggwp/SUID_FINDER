# !/bin/sh
DNS_TO_ADD="192.168.100.1"
RESOLV="/etc/resolv.conf"

ip link add br0 type bridge
ip link set br0 up
ip link set enp1s0 down
ip link set enp1s0 master br0
ip addr flush dev enp1s0

while true; do
    # проверяем есть ли IP у enp1s0
    IP=$(ip -br a | awk '/enp1s0/ {print $3}')
    echo "IP сброшен"
    if [ "$IP" = "" ]; then
        # если IP нет, добавляем DNS, если его ещё нет
        if ! grep -q "$DNS_TO_ADD" "$RESOLV"; then
            echo "DNS сброшен"
            echo "Добавляем DNS $DNS_TO_ADD в $RESOLV"
            echo "nameserver $DNS_TO_ADD" | sudo tee -a "$RESOLV"
            break
        fi
    fi

    sleep 1
done
ip addr add 192.168.100.202/24 dev br0
ip route add default via 192.168.100.1
ip link set enp1s0 up
echo -e "nameserver 192.168.100.1\nnameserver 8.8.8.8" | tee /etc/resolv.conf
