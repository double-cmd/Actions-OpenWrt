#!/bin/sh
# 月度自动更新: 备份 -> opkg 升级 -> AdGuardHome 核心
LOG=/tmp/autoupdate.log
echo "[$(date '+%F %T')] ===== 自动更新开始 =====" >> $LOG

BAK=/tmp/autobak/config-$(date +%Y%m%d).tar.gz
mkdir -p /tmp/autobak
tar -czf $BAK /etc/config /etc/passwall /etc/AdGuardHome 2>/dev/null
echo "备份完成: $BAK" >> $LOG

opkg update >> $LOG 2>&1

for p in luci-app-passwall luci-app-adguardhome luci-app-wechatpush \
          luci-app-upnp luci-app-ddns luci-app-filebrowser \
          luci-app-samba4 luci-app-minidlna luci-app-wol; do
	opkg upgrade $p >> $LOG 2>&1 || echo "$p 无更新或跳过" >> $LOG
done

if [ -x /usr/bin/AdGuardHome ]; then
	/usr/bin/AdGuardHome --update >> $LOG 2>&1 || echo "AdGuardHome 核心更新跳过" >> $LOG
fi

echo "[$(date '+%F %T')] 自动更新结束" >> $LOG
