#!/bin/sh
# OpenAppFilter 应用过滤 一键安装脚本 (iStoreOS/OpenWrt 24.10 aarch64)
# 用法: sh install.sh  (需与 packages/ 目录同目录)

cd "$(dirname "$0")" || exit 1

echo "==> 检查 kmod-oaf ..."
if opkg list-installed 2>/dev/null | grep -q kmod-oaf; then
    echo "    [OK] kmod-oaf 已安装"
else
    echo "    [警告] 未找到 kmod-oaf！"
    echo "    kmod-oaf 必须与内核匹配。iStoreOS 24.10 (xiaomeng9597 的 RK35XX/armv8 构建) 已自带；"
    echo "    其他固件请自行安装/编译: https://github.com/destan19/OpenAppFilter"
fi

echo "==> 安装 ipk ..."
opkg install ./packages/appfilter_*.ipk ./packages/luci-app-oaf_*.ipk ./packages/luci-i18n-oaf-zh-cn_*.ipk || {
    echo "[错误] 安装失败，请检查架构是否匹配 (aarch64_generic)"
    exit 1
}

echo "==> 启用并启动服务 ..."
/etc/init.d/appfilter enable 2>/dev/null
/etc/init.d/appfilter start 2>/dev/null
sleep 1

uci set appfilter.global.enable='1' 2>/dev/null
uci commit appfilter 2>/dev/null

echo "==> 验证 ..."
lsmod 2>/dev/null | grep oaf && echo "    内核模块 OK"
ps 2>/dev/null | grep oafd | grep -v grep && echo "    oafd 进程 OK"

echo ""
echo "==> 完成！"
echo "    打开: http://<路由器IP>/cgi-bin/luci/admin/services/appfilter"
echo "    (需要先登录 LuCI)"
