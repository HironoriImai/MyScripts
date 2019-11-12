#!/bin/bash

if [ ! -e "$1" ]; then
    echo "not found: $1"
    exit
fi

find "$1" -type f -exec chmod 644 {} \;
find "$1" -type d -exec chmod 755 {} \;
