#!/usr/bin/env bash

while :
do
    echo "#######STATUS:"
    find "$1" -type f -printf '%T+ %p SIZE: %s\n' | sort -r | head -n3
    echo "#######"
    sleep 10
done
