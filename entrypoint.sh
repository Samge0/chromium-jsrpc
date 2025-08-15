#!/bin/bash
set -e

# 启动jsrpc
chmod +x /app/linux_amd64
/app/linux_amd64 &

# 把 chromium 原始入口接过来
exec /init "$@"