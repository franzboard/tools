#!/bin/bash

# Testskript for TCP-Server nr@bulme.at 2020
#
# Beta Version!
#
# Usage:
# Download file, chmod 755 server-test.sh
#
# Each Project must be located in a separate subdirectory
#
# Scenario 1: Test multiple project subdirectories
# 
# ./server-test.sh (without any parameters)
#
# Scenario 2: Test single project subdirectory
# 
# ./server-test.sh my_project_subdirectory
#

EXE="myserver"
COMPILE_OPTS="-Wall"
TWAIT=3

function compile_check
{
    echo "Compile check"
    if gcc *.c -o $EXE $COMPILE_OPTS; then
        return 0
    else
        echo "Compile error!"
        return 1
    fi
}

function start_server
{
    # avoid "port is already in use" message
    export port=$(( RANDOM % 10000 +10000))
    ./$EXE $port  &
    if ps | grep $EXE ; then
        export SERVER_PID=$!
        echo "Started server on port $port with PID $SERVER_PID"
        return 0
    else
        echo "Could not start server"
        return 1
    fi
}

function connect_server
{
    echo "Connect server"
    nc 127.0.0.1 $port &
    if ! ps | grep "$!" ; then
        echo "Cannot connect server!"
        return 1
    fi
    export CLIENT_PID=$!
    return 0
}

function cpu_stress
{
    echo "CPU stress"
    for i in $(seq 1 100000); do echo "hallo" > /dev/null; done 
}

function cleanup
{
    [ ! -z "$SERVER_PID" ] && kill $SERVER_PID
    [ ! -z "$CLIENT_PID" ] && kill $CLIENT_PID
}

function run_all_checks
{
    compile_check || return 1
    start_server || return 1
    connect_server || return 1
    sleep $TWAIT
    cpu_stress
    return 0
}

SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
if [ "$#" -eq 0 ]; then
    for dir in $(ls); do
        echo "Checking $dir"
        cd "$dir"
        run_all_checks
        cleanup
        echo ""
        echo "Test $dir finished!"
        cd ..
        read -p "Continue (Y/n)?" REPLY
        if [[ $REPLY =~ ^[Nn]$ ]]; then
           break
        fi
    done
else
    dir="$1"
    echo "Checking $dir"
    cd "$dir"
    run_all_checks
    cleanup
    echo ""
    echo "Test $dir finished!"
fi
IFS=$SAVEIFS




