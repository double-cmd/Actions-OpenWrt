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

# 2. AdGuardHome 接管 DNS: dnsmasq 不再直连运营商 DNS, 统一转发到 AdGuard 的 5335 端口
#    不配这条的话 AdGuard 会空转: 客户端查询全走运营商, 过滤规则和统计数字全是 0
if [ -x /usr/bin/AdGuardHome ] && [ -x /etc/init.d/adguardhome ]; then
	uci set dhcp.@dnsmasq[0].noresolv='1'
	uci -q delete dhcp.@dnsmasq[0].server
	uci add_list dhcp.@dnsmasq[0].server='127.0.0.1#5335'
	uci commit dhcp
fi

exit 0
