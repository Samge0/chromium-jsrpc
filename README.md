# Chromium JsRPC Docker 项目

[![Docker Image](https://img.shields.io/docker/pulls/samge/chromium-jsrpc)](https://hub.docker.com/r/samge/chromium-jsrpc)
[![GitHub Actions](https://github.com/samge0/chromium-jsrpc/workflows/build%20docker%20image/badge.svg)](https://github.com/samge0/chromium-jsrpc/actions)

## 📖 项目简介

Chromium JsRPC 是一个基于 Docker 的容器化解决方案，集成了 Chromium 浏览器和 JsRpc 工具， 免证书配置。

## ✨ 主要特性

- 🐳 **容器化部署**: 基于 Docker 的轻量级部署方案
- 🌐 **Chromium 浏览器**: 集成最新版本的 `docker.cnb.cool/srebro/pidin/chromium` 浏览器
- 🔌 **JsRPC 支持**: 内置 JsRpc v1.095 工具，支持 JavaScript 远程调用

## 🚀 快速开始

### 方案1: 使用 Docker Compose（推荐）

```shell
docker compose -p chromium-jsrpc up -d
```

### 方案2: 使用 Docker 命令直接运行

```shell
docker run -itd \
--name chromium-jsrpc \
--hostname chromium \
--shm-size 4g \
--restart unless-stopped \
--security-opt seccomp=unconfined \
-e PUID=1000 \
-e PGID=1000 \
-e TZ=Asia/Shanghai \
-e CHROME_CLI=https://www.bing.com/ \
-e LANGUAGE=zh_CN:zh \
-e LANG=zh_CN.UTF-8 \
-e LC_ALL=C.UTF-8 \
-e TITLE=Pidin \
-p 53010:3000 \
-p 53011:3001 \
-p 52080:12080 \
-p 52443:12443 \
-v /var/run/docker.sock:/var/run/docker.sock \
-v ./docker_data/chromium/config:/config \
--device /dev/dri:/dev/dri \
samge/chromium-jsrpc:latest
```

### 方案3: 使用自定义 JsRPC 二进制文件

```shell
# 创建目录并下载 JsRPC 二进制文件
mkdir -p ./docker_data/jsrpc

curl -L -o ./docker_data/jsrpc/linux_amd64 \
  https://github.com/jxhczhl/JsRpc/releases/download/v1.095/linux_amd64

chmod +x ./docker_data/jsrpc/linux_amd64
chmod +x ./entrypoint.sh

# 启动自定义容器
docker compose -f docker-compose-custom.yaml up -d
```

## ⚙️ 配置选项

### 环境变量

| 变量名 | 默认值 | 说明 |
|--------|--------|------|
| `PUID` | 1000 | 用户ID |
| `PGID` | 1000 | 组ID |
| `TZ` | Asia/Shanghai | 时区设置 |
| `CHROME_CLI` | https://www.bing.com/ | 浏览器启动默认打开的页面 |
| `LANGUAGE` | zh_CN:zh | 语言设置 |
| `LANG` | zh_CN.UTF-8 | 语言环境 |
| `LC_ALL` | C.UTF-8 | 本地化设置 |
| `TITLE` | Pidin | 浏览器标题 |

### 端口映射

| 容器端口 | 主机端口 | 服务说明 |
|----------|----------|----------|
| 3000 | 53010 | chromium 浏览器访问端口 |
| 3001 | 53011 | chromium VNC访问端口 |
| 12080 | 52080 | JsRPC 默认端口  |
| 12443 | 52443 | JsRPC Https/wss端口 |

### 挂载目录

- `/var/run/docker.sock` → Docker 套接字（用于容器管理）
- `./docker_data/chromium/config` → Chromium 配置目录
- `./docker_data/jsrpc/linux_amd64` → 自定义 JsRPC 二进制文件（方案3）

## 🔧 高级配置

### 代理设置

如需配置代理，可以取消注释并修改以下环境变量：

```yaml
environment:
  http_proxy: "http://your-proxy:port"
  https_proxy: "http://your-proxy:port"
  no_proxy: "localhost,127.0.0.1,::1,192.168.*"
```

### 硬件加速

项目默认支持 DRI 设备挂载，如需启用硬件加速，确保主机支持并挂载 `/dev/dri` 设备。

### 安全配置

- `seccomp=unconfined`: 禁用 seccomp 安全策略（生产环境请谨慎使用）
- `--shm-size 4g`: 设置共享内存大小为 4GB

## 📁 项目结构

```
chromium-jsrpc/
├── .github/                    # GitHub Actions 配置
│   └── workflows/
│       └── docker-image.yml    # Docker 镜像构建工作流
├── docker_data/                # 数据目录（运行时创建）
│   ├── chromium/              # Chromium 配置
│   └── jsrpc/                 # JsRPC 二进制文件
├── Dockerfile                  # Docker 镜像构建文件
├── docker-compose.yaml         # Docker Compose 配置
├── docker-compose-custom.yaml  # 自定义 Docker Compose 配置
├── entrypoint.sh              # 容器启动脚本
├── .dockerignore              # Docker 忽略文件
├── .gitignore                 # Git 忽略文件
└── README.md                  # 项目说明文档
```

### 日志查看

```shell
# 查看容器日志
docker logs chromium-jsrpc

# 实时查看日志
docker logs -f chromium-jsrpc
```

## 🔄 更新和维护

### 更新镜像

```shell
# 拉取最新镜像
docker pull samge/chromium-jsrpc:latest

# 重启容器
docker restart chromium-jsrpc
```

### 构建自定义镜像

```shell
# 构建镜像
docker build -t chromium-jsrpc .

# 运行自定义镜像
docker run -d --name chromium-jsrpc my-chromium-jsrpc
```

## 📄 许可证

请遵守[JsRpc](https://github.com/jxhczhl/JsRpc)项目的 LICENSE 文件。

## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目！

## 📞 支持

如果您在使用过程中遇到问题，请：

1. 查看本文档的故障排除部分
2. 搜索已有的 Issue
3. 创建新的 Issue 并详细描述问题

## 鸣谢
- [JsRpc](https://github.com/jxhczhl/JsRpc)
- [Docker中开箱即用的浏览器 | Chromium 浏览器即容器](https://pidin.srebro.cn/archives/1745556963120)

---

**注意**: 本项目仅供学习和研究使用，请遵守相关法律法规和网站使用条款。