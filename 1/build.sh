docker build \
    -t mynginx \
    --build-arg NGINX_VERSION=1.27.4 \
    .