# Builder 阶段：编译 Go 可执行文件
FROM golang:alpine AS builder
WORKDIR /app

# 复制代码，并接收版本与提交号参数
COPY . .
ARG GITHUB_SHA
ARG VERSION

# 安装必要依赖（仅 Go 模块工具），无需 nodejs 和 zstd
RUN apk add --no-cache git \
 && go mod tidy \
 && echo "Building commit: ${GITHUB_SHA:0:7}" \
 && go build \
      -ldflags="-s -w \
        -X main.Version=${VERSION} \
        -X main.CurrentCommit=${GITHUB_SHA:0:7}" \
      -trimpath \
      -o main \
      .

# 运行时阶段：只保留最小运行环境和可执行文件
FROM alpine
ENV TZ=Asia/Shanghai

# 设置时区并安装证书；无需 nodejs
RUN apk add --no-cache ca-certificates alpine-conf \
 && /usr/sbin/setup-timezone -z Asia/Shanghai \
 && apk del alpine-conf \
 && rm -rf /var/cache/apk/*

# 拷贝从 builder 阶段编译好的可执行文件
COPY --from=builder /app/main /app/main

# 默认启动命令和端口声明
CMD ["/app/main"]
EXPOSE 8199
EXPOSE 8299
