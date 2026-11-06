#!/bin/sh
# 首次启动执行的固件定制脚本
# 1) 设置 LuCI 主题：优先 Vantage，缺失则回退 Argon
# 2) 设置 root 密码

# ---------- 主题 ----------
if [ -d /www/luci-static/vantage ]; then
	uci set luci.main.mediaurlbase='/luci-static/vantage'
	uci set luci.main.lang='zh_cn'
	uci commit luci
elif [ -d /www/luci-static/argon ]; then
	uci set luci.main.mediaurlbase='/luci-static/argon'
	uci set luci.main.lang='zh_cn'
	uci commit luci
fi

# ---------- root 密码 ----------
printf 'password\npassword\n' | passwd root 2>/dev/null || echo 'root:password' | chpasswd 2>/dev/null

exit 0
