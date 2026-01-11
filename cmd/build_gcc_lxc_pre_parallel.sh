#!/bin/sh

CONTNAME1="cont-1"
CONTNAME2="cont-2"
CONTNAME3="cont-3"
BUILD="/test/gcc-build"
LOGS="/test/logs"

run_in_container_parallel() {
    local name="$1"
    local cmd="$2"
    local host="$3"
    fly-term -e $cmd $name $host &
}

run_in_container_parallel "$CONTNAME1" "./cmd/build_gcc_lxc_pre.sh" "2"
run_in_container_parallel "$CONTNAME2" "./cmd/build_gcc_lxc_pre.sh" "3"
run_in_container_parallel "$CONTNAME3" "./cmd/build_gcc_lxc_pre.sh" "4"