#!/bin/sh
# 首次启动脚本 (uci-defaults): 执行一次后自动删除

# 1. 默认主题 Material
uci set luci.main.mediaurlbase=/luci-static/material
uci commit luci

# 2. 防火墙: WAN 放行 WireGuard UDP 51820
uci add firewall rule
uci set firewall.@rule[-1].name='Allow-WireGuard-VPN'
uci set firewall.@rule[-1].src='wan'
uci set firewall.@rule[-1].dest_port='51820'
uci set firewall.@rule[-1].proto='udp'
uci set firewall.@rule[-1].target='ACCEPT'
uci commit firewall

# 3. 脚本可执行权限
chmod +x /usr/bin/autoupdate.sh /usr/bin/network_monitor.sh

# 4. Netdata 仅监听内网
if [ -f /etc/netdata/netdata.conf ]; then
	sed -i 's/^# bind to = \*/bind to = 192.168.1.168/' /etc/netdata/netdata.conf
fi

exit 0
