#!/bin/sh
# 首次启动脚本 (uci-defaults): 执行一次后自动删除

# 1. 默认主题: 装了 Argon 就用 Argon, 没装则保持 Material (避免换肤失败导致界面无样式)
if [ -d /www/luci-static/argon ]; then
	uci set luci.main.mediaurlbase=/luci-static/argon
	uci commit luci
fi

exit 0
