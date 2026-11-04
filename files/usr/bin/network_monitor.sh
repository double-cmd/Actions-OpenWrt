#!/bin/sh
# 网络波动检测: 每 5 分钟 ping 外网, 异常微信告警
PING_HOST=223.5.5.5
LOG=/tmp/netmonitor.log
SCKEY_FILE=/etc/netmonitor_sckey

OUT=$(ping -c 5 -W 1 $PING_HOST 2>/dev/null)
LOSS=$(echo "$OUT" | grep -o '[0-9]*% packet loss' | head -1)
LAT=$(echo "$OUT" | grep -o 'time=[0-9.]*' | head -1)
[ -z "$LOSS" ] && LOSS="100% packet loss"
[ -z "$LAT" ] && LAT="time=n/a"

echo "$(date '+%F %T') 丢包:$LOSS 延迟:$LAT" >> $LOG

case "$LOSS" in
	100%*|8[0-9]%*|9[0-9]%*)
		LAST=$(cat /tmp/netmonitor_last 2>/dev/null)
		NOW=$(date +%s)
		if [ -z "$LAST" ] || [ $((NOW - LAST)) -gt 300 ]; then
			if [ -f $SCKEY_FILE ]; then
				KEY=$(cat $SCKEY_FILE)
				curl -s "https://sctapi.ftqq.com/$KEY.send?title=%E8%B7%AF%E7%94%B1%E5%99%A8%E7%BD%91%E7%BB%9C%E5%BC%82%E5%B8%B8&desp=%E4%B8%A2%E5%8C%85:$LOSS%0A%E5%BB%B6%E8%BF%9F:$LAT%0A%E6%97%B6%E9%97%B4:$(date '+%F %T')" >> $LOG 2>&1
				echo $NOW > /tmp/netmonitor_last
				echo "$(date '+%F %T') 已微信告警" >> $LOG
			fi
		fi
		;;
esac
