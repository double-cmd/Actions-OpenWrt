#!/bin/sh
# 首次启动脚本 (uci-defaults): 执行一次后自动删除

# 1. 默认主题: 装了 Vantage 就用 Vantage (用户选定), 否则回退 Argon / 保持 Material
#    (避免换肤失败导致界面无样式)
if [ -d /www/luci-static/vantage ]; then
	uci set luci.main.mediaurlbase=/luci-static/vantage
	uci commit luci
elif [ -d /www/luci-static/argon ]; then
	uci set luci.main.mediaurlbase=/luci-static/argon
	uci commit luci
fi

# 2. root 密码 (用户指定: password)
#    本镜像 busybox 没有 chpasswd applet, 用 passwd 非交互方式
printf 'password\npassword\n' | passwd root >/dev/null 2>&1 || \
	echo 'root:password' | chpasswd >/dev/null 2>&1

exit 0
