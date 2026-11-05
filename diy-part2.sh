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
for p in luci-app-ssr-plus luci-app-rclone luci-app-vssr luci-app-eqos-mtk; do
	sed -i "/^CONFIG_PACKAGE_${p}=y/d" .config 2>/dev/null
done

# 4. 默认主题换成 Argon (与现有路由器界面一致); 保留 material 作为兜底
sed -i '/^CONFIG_PACKAGE_luci-theme-argon=y/d' .config 2>/dev/null
echo "CONFIG_PACKAGE_luci-theme-argon=y" >> .config

# 5. AdGuardHome 本体编入固件: 官方界面, 免联网下载核心 (壳 luci-app-adguardhome 保留作快捷入口)
sed -i '/^CONFIG_PACKAGE_adguardhome=y/d' .config 2>/dev/null
echo "CONFIG_PACKAGE_adguardhome=y" >> .config

# 6. 自检: 确认关键改动真的落盘
grep -q "list ports 'eth0'" files/etc/config/network || echo "[WARN] network 端口未改成功"
grep -q "/luci-static/argon" files/etc/uci-defaults/99-custom.sh || echo "[WARN] 主题未改成功"
grep -q "luci-theme-argon" .config || echo "[WARN] argon 未写入 .config"
grep -q "^CONFIG_PACKAGE_adguardhome=y" .config || echo "[WARN] adguardhome 未写入 .config"

echo "diy-part2.sh done: 编译配置后处理完成"
