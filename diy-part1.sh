#!/bin/bash
# =============================================================
# diy-part1.sh — P3TERX/Actions-OpenWrt 模板: feeds update 前执行
# 接入第三方软件源 (PassWall / AdGuardHome / 微信推送)
# =============================================================

# PassWall 官方源 (luci-app-passwall + 依赖包 xray/sing-box/geoip)
git clone -b master --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall.git package/passwall-luci
git clone -b master --depth 1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git package/passwall-packages

# AdGuardHome 界面包 (核心程序刷机后 AdGuardHome --update 获取最新)
git clone -b master --depth 1 https://github.com/kongfl888/luci-app-adguardhome.git package/luci-app-adguardhome

# 微信推送: 不安装 luci 界面包 (wechatpush/serverchan 同源 i18n 冲突, 曾致编译失败)
# 网络波动告警已由 files/usr/bin/network_monitor.sh + Server酱 SCKEY 实现 (见 README 第 7 节)

echo "diy-part1.sh done: 第三方源已接入"
