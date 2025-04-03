FROM docker.io/caddy:builder AS builder

RUN xcaddy build --with github.com/caddy-dns/cloudflare --with github.com/caddy-dns/dnspod --with github.com/caddy-dns/alidns --with github.com/caddy-dns/namecheap --with github.com/caddy-dns/tencentcloud --with github.com/caddy-dns/cloudns --with github.com/caddy-dns/azure --with github.com/caddy-dns/acmedns --with github.com/caddy-dns/godaddy

FROM docker.io/caddy:latest

LABEL org.opencontainers.image.source=https://github.com/owent/update-caddy-docker

COPY --from=builder /usr/bin/caddy /usr/bin/caddy
COPY Caddyfile /etc/caddy/Caddyfile

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.tencent.com/g' /etc/apk/repositories; \
    apk add --no-cache tzdata; \
    cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime; \
    echo "Asia/Shanghai" > /etc/timezone; \
    apk add --no-cache nmap-ncat procps bash

EXPOSE 80
EXPOSE 443

# 容器启动命令
CMD ["caddy", "run", "--config", "/etc/caddy/Caddyfile", "--adapter", "caddyfile"]
