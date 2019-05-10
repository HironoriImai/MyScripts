#/bin/bash

# 東邦大学のWifiにログインするためのスクリプト

NAME="<学籍番号>"
read -sp "pass: " pass
curl -d "name=$NAME&pass=$pass&x=60&y=12" http://webauth.toho-u.ac.jp:8081/cgi-bin/adeflogin.cgi > /dev/null
