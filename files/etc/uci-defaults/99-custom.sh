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

exit 0
