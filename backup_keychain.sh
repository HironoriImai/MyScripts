#!/bin/bash

# キーチェーンの自動バックアップ（要暗号化dmgのパスワードのキーチェーン登録）

hdiutil attach ~/CloudStorage/Dropbox/keychain.dmg
cp ~/Library/Keychains/MyKeychain.keychain-db /Volumes/keychainDropbox/`date +%Y%m%d`_MyKeychain.keychain-db
rm /Volumes/keychainDropbox/`date -v-3m +%Y%m`*
hdiutil detach /Volumes/keychainDropbox