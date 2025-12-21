#!/bin/bash
set -e

TS=$(date +%Y%m%d_%H%M%S)

mkdir -p ~/logs/

cd $1 || exit 1
echo "Current path $1"
echo "Запускаем сборку $2"
/usr/bin/time -f "Real time %e сек  (user: %U сек, sys: %S сек)" make -j$(nproc) 2> ~/logs/"$2-$TS.log"
# time -f "Real time %e сек  (user: %U сек, sys: %S сек)" apt-get update 2&> ~/logs/"$2-$TS.log"