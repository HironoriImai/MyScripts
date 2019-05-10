#!/bin/bash

# 自炊した本（ISBNなし）に一意なLSDNを付与

if [ $# = 0 ]; then
    echo "usage: addisbn file1 [file2 file3 ...]"
fi
while [ $# -gt 0 ]; do
    ext=${1##*.}
    if [ $(tr '[A-Z]' '[a-z]' <<<$ext) = "pdf" ]; then
        filename="${1%.*}  LSDN$(date "+%y%m%d%w%H%M%S").pdf"
        mv "$1" "$filename" && echo "$1 => $filename"
    else
        echo "Error: $1 is not pdf file"
    fi
    shift
    sleep 1s
done
