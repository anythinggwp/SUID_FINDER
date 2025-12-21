#!/bin/bash
set -e

TERM="fly-term"
GCCSOURCE="/tmp/git"
BUILD1="/tmp/gcc-tmp-tty1/"
BUILD2="/tmp/gcc-tmp-tty2/"
BUILD3="/tmp/gcc-tmp-tty3/"
RESULT1="/tmp/gcc-tty1/"
RESULT2="/tmp/gcc-tty2/"
RESULT3="/tmp/gcc-tty3/"
GCCREPO="https://github.com/gcc-mirror/gcc"

run_build() {
    local buildDir="$1"
    local buildNum="$2"
    if [[ "$TERM" == "fly-term" ]]; then
        $TERM -e ./cmd/gcc_build_script.sh $buildDir $buildNum &
    fi
}

run_build "$BUILD1" "tty1"
run_build "$BUILD2" "tty2"
run_build "$BUILD3" "tty3"
