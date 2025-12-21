#!/bin/sh
set -e

CONTNAME1="cont-1"
CONTNAME2="cont-2"
CONTNAME3="cont-3"
GCCSOURCE="$HOME/git"
BUILD1="/tmp/gcc-tmp-tty1/"
BUILD2="/tmp/gcc-tmp-tty2/"
BUILD3="/tmp/gcc-tmp-tty3/"
RESULT1="/tmp/gcc-tty1/"
RESULT2="/tmp/gcc-tty2/"
RESULT3="/tmp/gcc-tty3/"
GCCREPO="https://github.com/gcc-mirror/gcc"

echo "Создаем контейнер"
sudo lxc-create -t astralinux-se -n "$CONTNAME1" 
sudo lxc-start -n "$CONTNAME1" 

run_in_container() {
    local name="$1"
    local cmd="$2"
    sudo lxc-attach -n "$CONTAINER_NAME" -- bash -c "$cmd" 
}

echo "Обновляем и устанавливаем зависимости в контейнер"
run_in_container "$CONTNAME1" "apt-get update && apt-get install -y build-essential gcc g++ make flex bison libgmp-dev libmpfr-dev libmpc-dev texinfo wget git"
sudo lxc-stop -n "$CONTNAME1" 
sudo rsync -av ~/git/gcc/ /var/lib/lxc/cont-1/rootfs/root/gcc/

# echo "Клонируем GCC (если еще не склонирован)..."
# run_in_container "mkdir -p $SRC_DIR && cd $SRC_DIR && if [ ! -d gcc ]; then git clone $GCC_REPO; fi"

# echo "Создаем папку сборки..."
# run_in_container "rm -rf $BUILD_DIR && mkdir -p $BUILD_DIR"

# echo "Конфигурируем сборку..."
# run_in_container "
# cd $BUILD_DIR
# $SRC_DIR/gcc/configure \
#     --prefix=$PREFIX_DIR \
#     --enable-languages=c \
#     --disable-multilib \
#     --disable-bootstrap \
#     --disable-libstdcxx \
#     --disable-libquadmath \
#     --disable-libsanitizer \
#     --disable-libssp \
#     --disable-libgomp \
#     --disable-libatomic \
#     --disable-nls
# "

# echo "Запускаем сборку GCC..."
# run_in_container "cd $BUILD_DIR && make -j\$(nproc)"

# echo "Установка GCC..."
# run_in_container "cd $BUILD_DIR && make install"

# echo "Сборка завершена. GCC установлен в $PREFIX_DIR внутри контейнера $CONTAINER_NAME"
