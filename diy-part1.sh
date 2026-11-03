#!/bin/bash
# =============================================================
# diy-part1.sh — P3TERX/Actions-OpenWrt 模板: feeds update 前执行
# 接入第三方软件源 (PassWall / AdGuardHome / 微信推送)
# =============================================================

git clone -b master --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall-luci
git clone -b master --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/passwall-packages
git clone -b master --depth 1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome
git clone -b master --depth 1 https://github.com/tty228/luci-app-serverchan.git package/luci-app-serverchan

echo "diy-part1.sh done: 第三方源已接入"
