#!/bin/bash

# deadman is made by Ryo Nakamura（https://github.com/upa/deadman）

# MIT License

# Copyright (c) 2018  Interop Tokyo ShowNet NOC team
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

################################################################################

# usage: ./deadman.sh <config file>
# usage: ./deadman.sh <IP or domain> [<IP or domain> ...]

deadman_origin="`dirname $0`/deadman_origin.py"
config="/tmp/deadman.conf"

if [ -z "$1" ]; then
    echo "google 8.8.8.8" > $config
elif [ -f "$1" ]; then
    config="$1"
else
    echo "" > $config
    for domain in "$@"; do
        # IPが指定された
        if [ "$domain" = "`echo $domain | egrep --only-matching '[0-9]{1,3}(\.[0-9]{1,3}){3}'`" ]; then
            echo "$domain $domain" >> $config
        else
            ip="`nslookup $domain | grep 'Address:' | grep -v '#' | egrep --only-matching '[0-9\.]+'`"
            if [ ! -z "$ip" ]; then
                echo "$domain $ip" >> $config
            fi
        fi
    done
fi

python $deadman_origin $config
