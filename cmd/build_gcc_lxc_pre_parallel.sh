#!/bin/sh

CONTNAME1="cont-1"
CONTNAME2="cont-2"
CONTNAME3="cont-3"
BUILD="/test/gcc-build"
LOGS="/test/logs"

run_in_container_parallel() {
    local name="$1"
    local cmd="$2"
    fly-term -e sudo "$cmd $name" &
}

run_in_container_parallel "$CONTNAME1" "./cmd/gcc_build_script.sh"
run_in_container_parallel "$CONTNAME2" "./cmd/gcc_build_script.sh"
run_in_container_parallel "$CONTNAME3" "./cmd/gcc_build_script.sh"