#!/bin/bash
# flutter clean
flutter build apk

# 设置临时代理
# 上传fir
./go-fir-cli -t 13581c4350ed341b416a26cd998f7064 upload -f build/app/outputs/apk/release/app-release.apk
