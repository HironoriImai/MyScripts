#!/bin/bash
# VLCが起動してるとPCがスリープに移行しないので，
# スクリーンセーバ中10分より長く起動してたら終了させる．
# ※システム設定：スクリーンセーバ：5分，スリープ：20分

# DB（テキスト）ファイルの場所
dbfile="/tmp/stop_vlc.txt"

# スクリーンセーバが起動していなかったらDBファイルを削除
ss=`ps ax | grep "ScreenSaverEngine.app" | grep -v "grep"`
if [ -z "$ss" ]; then
    [ -e $dbfile ] && rm $dbfile
    exit
fi

nowplaying=`/usr/sbin/lsof | grep -e "^VLC.*\.mp4$"`
# VLCが再生中でなかったら何もせず終了
[ -z "$nowplaying" ] && exit

# スクリーンセーバ中の連続起動時間を計算
current=0
if [ -f $dbfile ]; then
    current=`cat $dbfile`
fi
current=$((current += 2))
# 10分より長く起動してたら終了
if [ $current -gt 10 ]; then
    /usr/bin/killall VLC
else
    echo $current > $dbfile
fi
