#!/bin/bash
# =============================================================
# diy-part2.sh — P3TERX/Actions-OpenWrt 模板: feeds update/install 后执行
# 编译配置后处理
# =============================================================

# 1. 用 dnsmasq-full 替代默认 dnsmasq
sed -i 's/^CONFIG_PACKAGE_dnsmasq=y/# CONFIG_PACKAGE_dnsmasq is not set/' .config

# 2. 单设备固件: 移除其他设备定义
sed -i '/^CONFIG_TARGET_DEVICE_mediatek_filogic_DEVICE_/!b; /glinet_gl-mt3000/d' .config 2>/dev/null

# 3. 移除不需要的默认应用
#    - Web 终端 ttyd: 用户明确不需要, 且会开 7681 端口
#    - netdata 监控: 用户要求卸载, 且会开 19999 端口
ttyd_list="luci-app-ttyd ttyd luci-i18n-ttyd-zh-cn"
netdata_list="luci-app-netdata netdata luci-i18n-netdata-zh-cn"
for p in luci-app-ssr-plus luci-app-rclone luci-app-vssr luci-app-eqos-mtk $ttyd_list $netdata_list; do
	sed -i "/^CONFIG_PACKAGE_${p}=y/d" .config 2>/dev/null
done
for p in luci-app-ttyd ttyd luci-i18n-ttyd-zh-cn luci-app-netdata netdata luci-i18n-netdata-zh-cn; do
	sed -i "/^CONFIG_PACKAGE_${p}=/d" .config 2>/dev/null
done

# 4. 默认主题 Vantage (用户选定): 外部源码编入主题+仪表盘+中文语言包
#    (一个仓库含 luci-theme-vantage 与 luci-app-vantage 两个包, 分开放到 package/)
git clone -q --depth 1 https://github.com/anothaDev/luci-theme-vantage.git /tmp/vantage-src
cp -r /tmp/vantage-src/luci-theme-vantage package/
cp -r /tmp/vantage-src/luci-app-vantage package/
rm -rf /tmp/vantage-src
for p in luci-theme-vantage luci-app-vantage luci-i18n-vantage-zh-cn luci-i18n-vantage-theme-zh-cn; do
	sed -i "/^CONFIG_PACKAGE_${p}=y/d" .config 2>/dev/null
	echo "CONFIG_PACKAGE_${p}=y" >> .config
done

# 5. 保留 Argon 作兜底主题 (Vantage 异常时可切回)
sed -i '/^CONFIG_PACKAGE_luci-theme-argon=y/d' .config 2>/dev/null
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> .config

# 6. AdGuardHome 本体编入固件: 官方界面, 免联网下载核心 (壳 luci-app-adguardhome 保留作快捷入口)
sed -i '/^CONFIG_PACKAGE_adguardhome=y/d' .config 2>/dev/null
echo "CONFIG_PACKAGE_adguardhome=y" >> .config

# 7. 微信推送 PushPlus (用户要求): tty228/luci-app-wechatpush
#    支持 推送加(PushPlus) / Server酱 / WxPusher / WPUSH / 企业微信 / Telegram / 邮件
#    依赖: iputils-arping + curl + jq + bash
git clone -q --depth 1 https://github.com/tty228/luci-app-wechatpush.git /tmp/wp-src
cp -r /tmp/wp-src package/luci-app-wechatpush
rm -rf /tmp/wp-src
for p in luci-app-wechatpush iputils-arping curl jq bash; do
	sed -i "/^CONFIG_PACKAGE_${p}=/d" .config 2>/dev/null
	echo "CONFIG_PACKAGE_${p}=y" >> .config
done

# 8. 清理 netdata 配置残留 (不再随固件携带)
rm -f files/etc/netdata/netdata.conf
rmdir files/etc/netdata 2>/dev/null

# 9. 自检: 确认关键改动真的落盘 (网口映射: eth0=2.5G WAN, eth1=1G LAN)
grep -q "list ports 'eth1'" files/etc/config/network || echo "[WARN] br-lan 未指向 eth1"
grep -q "option device 'eth0'" files/etc/config/network || echo "[WARN] wan 未指向 eth0"
grep -q "option username" files/etc/config/network || echo "[WARN] 宽带账号未写入"
grep -q "/luci-static/vantage" files/etc/uci-defaults/99-custom.sh || echo "[WARN] 主题未改成功"
grep -q "luci-theme-vantage" .config || echo "[WARN] vantage 未写入 .config"
grep -q "^CONFIG_PACKAGE_adguardhome=y" .config || echo "[WARN] adguardhome 未写入 .config"
grep -q "^CONFIG_PACKAGE_luci-app-wechatpush=y" .config || echo "[WARN] wechatpush 未写入 .config"
grep -q "^CONFIG_PACKAGE_ttyd=y" .config && echo "[WARN] ttyd 仍然存在"
grep -q "^CONFIG_PACKAGE_netdata=y" .config && echo "[WARN] netdata 仍然存在"
[ -d package/luci-theme-vantage ] || echo "[WARN] vantage 源码未 clone 到 package"
[ -d package/luci-app-wechatpush ] || echo "[WARN] wechatpush 源码未 clone 到 package"

echo "diy-part2.sh done: 编译配置后处理完成"
