# GL-MT3000 定制固件编译与刷机手册

> ImmortalWrt 24.10 (内核 6.6) + MTK 闭源 WiFi 驱动 · 云编译 (GitHub Actions)
> 基于 padavanonly/immortalwrt-mt798x-6.6 (237 大佬) 源码 · 设备 GL.iNet GL-MT3000 (MT7981B)

---

## 一、固件方案概要

| 项 | 值 |
|---|---|
| 系统 | ImmortalWrt 24.10 (OpenWrt 24.10 内核 6.6) |
| WiFi 驱动 | MTK 闭源 (kmod-mt_wifi + kmod-warp + kmod-mediatek_hnat 硬件加速) |
| 管理地址 | **192.168.1.168** (登录地址 = 默认网关 = failsafe 救援 IP) |
| WAN | 2.5G 口 (eth0) · PPPoE 宽带账号已预置 |
| LAN | 千兆口 (eth1) · DHCP 自动分配 192.168.1.100-250 / 12h |
| WiFi | **默认关闭** (需要时在无线页面开启) |
| root 密码 | 与现机一致 (已预置哈希) |
| 主题 | Material (编译预置默认, 美观简洁) |

### 预装清单 (30 项)

代理 **PassWall**(xray内核) · 去广告 **AdGuardHome** · 微信推送(Server酱脚本) · UPnP · 网络加速(Fullcone/HNAT) · 动态DNS · 网络唤醒 · **SMB共享** · MiniDLNA · 中文全量 · Material主题 · USB自动挂载(exfat/ntfs3) · 磁盘管理(diskman) · 流量统计(wrtbwmon) · WiFi管理(mtwifi-cfg) · zram内存优化 · **WireGuard加密VPN服务端** · **FileBrowser美化版文件管理** · **netdata实时监控** · **speedtest-go测速** · 网络波动监测(微信告警) · 月度自动更新 · 每周自动重启

### 已预置 (刷完即用)
- 网络: LAN 192.168.1.168 / WAN PPPoE(账号已填) / 2.5G=WAN 千兆=LAN
- root 密码 (与现机相同)
- failsafe 救援 IP = 192.168.1.168 (长按 reset 进救援模式也走这个 IP)
- 防火墙: WAN 放行 WireGuard UDP 51820
- 定时任务: 每月1日3:00自动更新 · 每周日4:00自动重启 · 每5分钟网络监测
- 默认主题 Material

---

## 二、GitHub 云编译步骤 (约 1.5-3 小时)

### 第 1 步: Fork 编译模板
1. 打开 https://github.com/P3TERX/Actions-OpenWrt 点击右上角 **Fork** (用 zanwang89@gmail.com 账号)
2. Fork 完成后进入你自己的仓库 (你的账号/Actions-OpenWrt)

### 第 2 步: 上传编译配置
把本目录 (`firmware-build/`) 里这些文件/文件夹上传到仓库根目录:
- `.config` (编译配置)
- `diy-part1.sh` (第三方源接入)
- `diy-part2.sh` (配置后处理)
- `files/` (预置配置文件夹: 网络/密码/定时任务/脚本)

上传方法: 仓库页面 → Add file → Upload files → 拖入上述文件 → Commit

### 第 3 步: 触发编译
1. 仓库页面点 **Actions** 标签
2. 左侧选 **Build OpenWrt** 工作流
3. 点 **Run workflow** → 绿色按钮 → 开始编译
4. 等待 1.5-3 小时 (可关闭页面, 完成后 GitHub 会发邮件通知)

### 第 4 步: 下载固件
1. 编译完成后 Actions 页面该次运行显示成功 (绿色 ✓)
2. 展开 **Artifacts** → 下载 zip (内含 **openwrt-mediatek-filogic-glinet_gl-mt3000-squashfs-sysupgrade.bin**)

> ⚠️ 若编译失败: 展开失败步骤看红色日志, 通常是第三方源更新导致包名变化。把错误日志截图发给我, 我来修配置再跑。

---

## 三、刷机步骤 (10 分钟)

> 现机完整备份已在 `C:\Users\Amine\Doubao\chats\2026-11-03\new-chat-2\backup-20261104\` (配置/PassWall/AdGuardHome/包清单/shadow 全齐)

1. 解压固件 zip, 确认文件名含 **squashfs-sysupgrade.bin**
2. 浏览器打开 http://192.168.1.168 登录现机
3. **系统 → 备份/恢复 → 生成备份** (多存一份现机备份保险)
4. **系统 → 刷机 (Flash)** → 选择固件文件 → 上传
5. **不要勾选"保留配置"** (全新安装, 避免旧配置冲突)
6. 点刷机 → 等待进度条完成 → 路由器自动重启 (约 3-5 分钟)
7. 重启后: **拔掉 WAN 网线** → 电脑接 LAN 口 → 浏览器打开 **http://192.168.1.168**
8. 用户名 `root` / 密码 = 你现机的密码 (已预置)

---

## 四、刷机后配置 (按顺序做, 约 30 分钟)

### 1. 接宽带
插好 WAN 网线 → 登录路由器 → **网络 → 接口** → 确认 WAN 已自动拨号获取公网 IP

### 2. PassWall (代理)
- **服务 → PassWall**
- 填入你的节点/订阅 (跟现机一样)
- 内核确认: 全局设置 → 主程序选 **Xray**
- 开启后测试节点连通性 (测试按钮)

### 3. AdGuardHome (去广告)
- **服务 → AdGuardHome**
- 界面提示安装核心时点"更新/安装" (核心程序官方最新, 或 SSH 执行 `AdGuardHome --update`)
- 设置监听: 网页端口 28075 (跟现机一致), DNS 端口 53 冲突时改 5553 并让 PassWall 转发
- **过滤器 → DNS 拦截清单** 添加规则订阅 (推荐: anti-AD / 乘风规则, 网上搜索现成订阅链接粘贴)

### 4. WireGuard 加密 VPN (远程安全接入)
- **网络 → 接口 → 添加新接口**: 协议 **WireGuard VPN**
  - 名称: `wg0` · 私钥: 生成 (接口页有生成按钮)
  - IP 地址: `10.0.0.1/24` · 监听端口: **51820**
- **添加对端 (客户端)**: 
  - 公钥: 客户端设备生成的公钥 (手机/电脑装 WireGuard 官方 App 生成)
  - 允许的 IP: `0.0.0.0/0, ::/0` (整条隧道)
- 客户端配置: 填写你的 DDNS 域名 + 51820 + 客户端的私钥/公钥对
- 公网访问已验证: 防火墙已预置放行 51820/udp (不需再开)
- 完成后: 手机开流量 → 连 WireGuard → 应能访问 192.168.1.168 (LuCI/文件/内网全通, 全程加密)

### 5. FileBrowser (美化版文件管理)
- **服务 → FileBrowser** (通过 LuCI 进入)
- 首次登录: 默认账号 `admin` / 密码 `admin` → **立即修改密码** (建议强密码)
- 挂载你的 USB 盘目录 (如 /mnt/sda1)
- 远程访问: 走 WireGuard 隧道即可 (http://192.168.1.168/cgi-bin/luci/admin/filebrowser), **无需开放公网端口**

### 6. SMB 共享 (重建现机共享 qaz)
- **服务 → 网络共享 (Samba)**
- 共享目录: 你的 USB 盘 (如 /mnt/sda1) · 共享名: `qaz` (与现机一致)
- 启用后电脑访问: `\\192.168.1.168\qaz`

### 7. 微信推送 + 网络监测告警 (Server酱)
> 说明: 微信推送采用 Server酱接口 (由预装脚本 network_monitor.sh 调用), 无需安装 LuCI 界面包 (wechatpush/serverchan 界面包同源冲突, 故不预装)
- SSH 登录路由器, 写入你的 Server酱 SCKEY:
  `echo "你的SCKEY" > /etc/netmonitor_sckey`
- 网络异常会自动微信告警 (每 5 分钟检测一次, 断线/高丢包触发)
- 测试: SSH 执行 `sh /usr/bin/network_monitor.sh` 查看 /tmp/netmonitor.log

### 8. 动态 DNS (公网动态 IP 绑定域名)
- **服务 → 动态 DNS**
- 新增: 你的域名 + 服务商 + 账号密码 → 启用
- 用于 WireGuard 远程接入域名解析

### 9. 网络加速 (可选微调)
- **网络 → 网络加速 (turboacc-mtk)** → 开启 **Fullcone NAT** + 硬件加速 (默认已优化, 确认开关即可)

### 10. 验证清单
- [ ] 微信推送测试成功 (写入 SCKEY 后断网触发告警)
- [ ] AdGuardHome 拦截生效 (网页广告减少)
- [ ] PassWall 节点连通
- [ ] WireGuard 手机流量下能访问路由器
- [ ] SMB 电脑能访问 \\192.168.1.168\qaz
- [ ] FileBrowser 网页能浏览硬盘文件
- [ ] 磁盘管理 (系统→磁盘管理) 显示 USB 盘容量
- [ ] netdata (http://192.168.1.168:19999) 显示 CPU/内存图表
- [ ] 测速: SSH 执行 `speedtest-go`
- [ ] WiFi 未开启 (默认关闭, 需要时再开)

---

## 五、常用信息速查

| 项 | 值 |
|---|---|
| 管理地址 | http://192.168.1.168 |
| SSH | ssh root@192.168.1.168 (密码=现机密码) |
| AdGuardHome | 网页端口 28075 |
| netdata 监控 | http://192.168.1.168:19999 (仅内网) |
| WireGuard | UDP 51820 |
| SMB | \\192.168.1.168\qaz |
| 月度更新 | 每月1日 03:00 自动 (备份+升级) |
| 每周重启 | 每周日 04:00 |
| failsafe | 长按 reset 开机 → 192.168.1.168 救援模式 |

### 回滚 (出问题怎么办)
- **配置出问题**: /tmp/autobak/ 有自动备份, 或恢复现机备份 backup-20261104
- **固件不行**: LuCI 系统→备份/恢复→刷回 iStoreOS 原固件 (备份文件在 backup-20261104/, 原厂固件可到 GL.iNet 官网下载)
- **无法开机**: 长按 reset 进 failsafe → 网页 192.168.1.168 恢复出厂或重刷
