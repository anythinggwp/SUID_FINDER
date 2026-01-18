#!/bin/bash

echo "Обновляем список пакетов"

apt update
apt install -y build-essential libncurses-dev bison flex libssl-dev libelf-dev bc git wget

echo "Устанавливаем Go"

wget --no-clobber https://go.dev/dl/go1.25.6.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go1.25.6.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
go version

echo "Устанавливаем syzkaller"
if [ ! -d "syzkaller" ]; then
    git clone https://github.com/google/syzkaller.git "syzkaller"
else
    echo "Репозиторий уже существует, пропускаем клонирование."
fi
cd syzkaller
make
