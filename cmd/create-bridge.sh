# !/bin/sh
RESOLV="/etc/resolv.conf"
BACKUP="/etc/resolv.conf.backup"
# делаем копию файла с адресамии dns, чтобы востанвить после flush
cp "$RESOLV" "$BACKUP"

# Создаем мост
echo "Создаем мост"
ip link add br0 type bridge
ip link set br0 up

# Привязываем физ интерфейс к мосту
echo "Привязываем интерфейс к мосту"
ip link set enp1s0 down
ip link set enp1s0 master br0
ip addr flush dev enp1s0

echo "Сброс настроек физического интерфейса"
while true; do
    # проверяем есть ли IP у enp1s0
    IP=$(ip -br a | awk '/enp1s0/ {print $3}')
    
    if [ "$IP" = "" ]; then
    echo "IP сброшен, ожидаем сброс DNS"
        if ! grep -q "nameserver" "$RESOLV"; then
            echo "DNS сброшен"
            cp "$BACKUP" "$RESOLV"
            rm "$BACKUP"
            break
        fi
    fi

    sleep 1
done
echo "Продолжаем настройку моста"
# конфигурируем мост
ip addr add 192.168.100.202/24 dev br0
ip route add default via 192.168.100.1
ip link set enp1s0 up
