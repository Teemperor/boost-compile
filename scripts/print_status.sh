#!/usr/bin/env bash

while :
do
    find "$1" -printf '%T+ %p SIZE: %s\n' | sort -r | head -n10
    sleep 10
done
