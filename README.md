# iStoreOS 应用过滤 (OpenAppFilter) 安装包 — ARM (aarch64)

为 **iStoreOS / OpenWrt 24.10 (aarch64_generic / RK35XX·armv8 等 ARM 软路由/路由器)** 提供 **应用过滤 (App Filter)** 的完整安装包。

## 为什么需要这个

很多 ARM 版 iStoreOS 固件（例如 xiaomeng9597 的 `iStoreOS-RK35XX-24.10-NSY` 构建）**只内置了内核模块 `kmod-oaf`，却没有用户态程序 `appfilter` 和 LuCI 界面 `luci-app-oaf`**，导致"应用过滤"功能在网页里找不到。本仓库提供缺失的 3 个 ipk，装上即可使用。

> 内核模块 `kmod-oaf` 请确认已存在：`opkg list-installed | grep kmod-oaf`
> （iStoreOS 24.10 的 xiaomeng9597 构建自带；其他固件需自行安装/编译与内核匹配的 kmod-oaf，见文末说明）

## 文件说明

| 文件 | 版本 | 架构 | 说明 |
|---|---|---|---|
| `packages/appfilter_*.ipk` | 6.1.3 | aarch64_generic | 用户态守护进程 oafd + 特征库 + 启动脚本 |
| `packages/luci-app-oaf_*.ipk` | 6.1.1 | all | LuCI 界面（应用过滤/用户配置/时间/高级设置） |
| `packages/luci-i18n-oaf-zh-cn_*.ipk` | 25.129 | all | 中文语言包 |
| `install.sh` | - | - | 一键安装脚本 |

## 安装方法

### 方法一：一键脚本（推荐）

把整个仓库（`install.sh` + `packages/`）上传到路由器任意目录（如 `/tmp`），然后：

```sh
cd /tmp            # 或你上传的目录
sh install.sh
```

### 方法二：手动安装

```sh
# 1. 上传 3 个 ipk 到路由器 /tmp 后执行
opkg install /tmp/appfilter_*.ipk /tmp/luci-app-oaf_*.ipk /tmp/luci-i18n-oaf-zh-cn_*.ipk

# 2. 启用并启动服务
/etc/init.d/appfilter enable
/etc/init.d/appfilter start

# 3. 开启功能
uci set appfilter.global.enable='1'
uci commit appfilter
```

### 使用

浏览器打开（需先登录 LuCI）：

```
http://<路由器IP>/cgi-bin/luci/admin/services/appfilter
```

页面包含：**应用过滤**（按 App 封禁）、**用户配置**（按设备/IP 生效）、**时间配置**、**高级设置**、**App Feature**（特征库管理/更新）。

## 验证是否生效

```sh
lsmod | grep oaf          # 应看到 oaf 模块
ps | grep oafd            # 应看到 oafd 进程
uci show appfilter.global # enable 应为 '1'
```

## 常见问题

**Q: 提示 `Unknown package` 或找不到 kmod-oaf？**
A: `kmod-oaf` 必须与你的内核版本严格匹配。iStoreOS 24.10（xiaomeng9597 的 RK35XX/armv8 构建）已自带；其他固件需要：
- 从你固件的软件源安装匹配的 `kmod-oaf`（如有）
- 或自行编译：[destan19/OpenAppFilter](https://github.com/destan19/OpenAppFilter)

**Q: 我是 x86 路由器，能装吗？**
A: 本仓库的 `appfilter` 是 **aarch64** 架构，x86 请使用 `x86_64` 版本（多数 x86 iStoreOS 固件已内置本功能，无需安装）。

**Q: 特征库识别不准？**
A: 在页面"App Feature"标签里在线更新特征库。

**Q: 安装后页面打不开？**
A: 需要先登录 LuCI；确认 `/etc/init.d/appfilter status` 为 running。

## 致谢

- 内核模块与协议识别：[destan19/OpenAppFilter](https://github.com/destan19/OpenAppFilter)
- 打包来源：xiaomeng9597 的 [ImmortalWrt-NSY](https://github.com/xiaomeng9597/ImmortalWrt-NSY) 发布包（aarch64_generic）

## 免责声明

本仓库仅收集整理官方开源组件，仅供学习交流使用，请遵守当地法律法规。
