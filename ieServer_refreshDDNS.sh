#!/bin/bash

# ieServerのDDNS更新用スクリプト

LOG_DIR="/var/log/RefreshDDNS"
LOG_FILE="$LOG_DIR/`date '+%Y-%m'`.log"
IPADDR_FILE="$LOG_DIR/ipaddr.txt"

username="<ユーザ名>"
domain="<ドメイン名>"
password="<パスワード>"

# IP更新
refresh_ip(){
    response=$(curl -X POST -d "username=$username" -d "domain=$domain" -d "password=$password" -d "updatehost=IP登録" https://ieserver.net/cgi-bin/dip.cgi 2> /dev/null)
	[ "`echo $response | grep Error`" != "" ] && return 1
	return 0
}

# ログに書き込み
log_write() {
    echo "`date '+%Y-%m-%d_%H:%M:%S'` $1" >> $LOG_FILE
}

#################################################

# グローバルIPアドレスを取得
declare -a ifconfig_url=('ifconfig.moe' 'ifconfig.me' 'ipcheck.ieserver.net')
IPADDR=`curl -sS ${ifconfig_url[$RANDOM%3]}`


# 取得したIPが正規表現に一致しない：ログを出力して終了
if [[ ! "$IPADDR" =~ [0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3} ]]; then
    log_write "'$IPADDR' is not ip address. exit."
    exit -1
fi

# IPに変更があった：IP更新・ログを出力
if [ "`head -n 1 $IPADDR_FILE`" != "$IPADDR" ]; then
    refresh_ip
    if [ $? -eq 0 ]; then
        log_write "register new ip address '$IPADDR'."
        echo "$IPADDR" > $IPADDR_FILE
        echo "$(expr \( `date '+%d'` - 2 \) / 10)" >> $IPADDR_FILE
    else
        log_write "failed: register new ip address '$IPADDR'."
    fi
# 前回更新時から10日経過：IP更新・ログを出力
elif [ "$(expr \( `date '+%d'` - 2 \) / 10)" != "`tail -n 1 $IPADDR_FILE`" ]; then
    refresh_ip
    if [ $? -eq 0 ]; then
        log_write "refresh current ip address '$IPADDR'."
        echo "$(expr \( `date '+%d'` - 2 \) / 10)" >> $IPADDR_FILE
    else
        log_write "failed: refresh current ip address '$IPADDR'."
    fi
# IPに変更がない：ログの出力のみ
else
    log_write "ip address is not changed '$IPADDR'."
fi
