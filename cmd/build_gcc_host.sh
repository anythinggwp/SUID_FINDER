#!/bin/bash
set -e

TERM="kitty"
GCCSOURSE="/tmp/git"
BUILD1="/tmp/gcc-tmp-tty1/"
BUILD2="/tmp/gcc-tmp-tty2/"
BUILD3="/tmp/gcc-tmp-tty3/"
GCCREPO="https://github.com/gcc-mirror/gcc"
# Список зависимостей
dependencies=(
    build-essential
    gcc
    g++
    make
    flex
    bison
    libgmp-dev
    libmpfr-dev
    libmpc-dev
    texinfo
    wget
)

# Только для пакетного менеджера apk
echo "Проверка и установка зависимостей..."

for pkg in "${dependencies[@]}"; do
    if ! dpkg -s "$pkg" >/dev/null 2>&1; then
        echo "Устанавливаем $pkg..."
        sudo apt-get install -y "$pkg"
    else
        echo "$pkg уже установлен"
    fi
done

echo "Все зависимости установлены"

echo "Загрузка gcc c git"

mkdir -p $GCCSOURSE
cd $GCCSOURSE
git clone $GCCREPO


run_build() {
    local build_dir="$1"
    local term_title="$2"

    $TERM bash -c "
        echo 'Начинаем сборку в $build_dir ...'
        sleep 60
    " &
}

run_build "$BUILD1" "Build1" 
run_build "$BUILD2" "Build2" 
run_build "$BUILD3" "Build3" 