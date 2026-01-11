#!/bin/sh

CONTNAME1="cont-1"
CONTNAME2="cont-2"
CONTNAME3="cont-3"
BUILD="/test/gcc-build"
LOGS="/test/logs"

run_in_container_parallel() {
    local name="$1"
    local cmd="$2"
    fly-term -e sudo lxc-attach -n "$name" -- bash -c "$cmd" &
}

run_in_container_parallel "$CONTNAME1" "cd $BUILD && /usr/bin/time -o $LOGS -f 'Real time %e сек  (user: %U сек, sys: %S сек)' make -j$(nproc)"
run_in_container_parallel "$CONTNAME2" "cd $BUILD && /usr/bin/time -o $LOGS -f 'Real time %e сек  (user: %U сек, sys: %S сек)' make -j$(nproc)"
run_in_container_parallel "$CONTNAME3" "cd $BUILD && /usr/bin/time -o $LOGS -f 'Real time %e сек  (user: %U сек, sys: %S сек)' make -j$(nproc)"