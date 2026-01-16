#!/bin/bash
# docker-entrypoint.sh
set -e  # 任何命令失败则脚本退出

# 启动node并后台运行
node /app/metacubex/server/index.mjs > /app/node.log 2>&1 &
NODE_PID=$!

# 检查node启动状态
sleep 2
if ! ps -p $NODE_PID > /dev/null; then
    echo "Node启动失败，查看日志：/app/node.log"
    exit 1
fi

# 启动/mihomo（作为容器PID 1进程，保证容器不退出）
exec /mihomo