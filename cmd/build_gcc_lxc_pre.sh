#!/bin/sh
set -e

CONTNAME1="cont-1"
CONTNAME2="cont-2"
CONTNAME3="cont-3"
GCCSOURCE="$HOME/git"
BUILD="/test/gcc-build"
LOGS="/test/logs"
GCCREPO="https://github.com/gcc-mirror/gcc"

echo "Создаем контейнер"
sudo lxc-create -t astralinux-se -n "$CONTNAME1"
sudo lxc-start -n "$CONTNAME1"

run_in_container() {
    local name="$1"
    local cmd="$2"
    sudo lxc-attach -n "$name" -- bash -c "$cmd"
}

echo "Обновляем и устанавливаем зависимости в контейнер"
run_in_container "$CONTNAME1" "apt-get update && apt-get install -y build-essential gcc g++ make flex bison libgmp-dev libmpfr-dev libmpc-dev texinfo wget git time"
run_in_container "$CONTNAME1" "mkdir -p $BUILD $LOGS /opt/gcc-test-build"
sudo lxc-stop -n "$CONTNAME1"

echo "Копируем исходники gcc в контейнер"
sudo rsync -av ~/git/gcc/ /var/lib/lxc/cont-1/rootfs/root/gcc/
sudo lxc-start -n "$CONTNAME1"

echo "Запускаем конфигурирование сборки"

run_in_container "$CONTNAME1" "cd $BUILD && /root/gcc/configure \
    --prefix=/opt/gcc-test-build \
    --enable-languages=c \
    --disable-multilib \
    --disable-bootstrap \
    --disable-libstdcxx \
    --disable-libquadmath \
    --disable-libsanitizer \
    --disable-libssp \
    --disable-libgomp \
    --disable-libatomic \
    --disable-nls
"
sudo lxc-stop -n "$CONTNAME1"

echo "Клонируем контейнеры"
sudo lxc-copy -n "$CONTNAME1" -N "$CONTNAME2"
sudo lxc-copy -n "$CONTNAME1" -N "$CONTNAME3"

# echo "Запускаем контейнеры"
# sudo lxc-start -n "$CONTNAME1"
# sudo lxc-start -n "$CONTNAME2"
# sudo lxc-start -n "$CONTNAME3"

# run_in_container_parallel "$CONTNAME1" "cd $BUILD /usr/bin/time -o $LOGS -f 'Real time %e сек  (user: %U сек, sys: %S сек)' make -j$(nproc)"
# run_in_container_parallel "$CONTNAME2" "cd $BUILD /usr/bin/time -o $LOGS -f 'Real time %e сек  (user: %U сек, sys: %S сек)' make -j$(nproc)"
# run_in_container_parallel "$CONTNAME3" "cd $BUILD /usr/bin/time -o $LOGS -f 'Real time %e сек  (user: %U сек, sys: %S сек)' make -j$(nproc)"

