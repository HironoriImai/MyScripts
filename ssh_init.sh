#!/bin/bash

# ~/.ssh 以下のssh秘密鍵をagentに登録する

for file in `find ~/.ssh -name '*.pub'`; do
    key=${file%.*}
    echo $key
    read -p "$key を追加しますか？ [y/N] (default:y) : " res
    if [ "$res" != "n" -a "$res" != "N" ]; then
        ssh-add $key
    fi
done