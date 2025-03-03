FROM alpine/git:v2.47.2 as builder

ARG NGINX_VERSION

RUN apk upgrade --no-cache

RUN apk add --no-cache wget build-base pcre pcre-dev zlib zlib-dev openssl-dev gd-dev libxml2 libxml2-dev util-linux-dev

RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz && \
    tar -zxvf nginx-${NGINX_VERSION}.tar.gz -C / && \
    rm nginx-${NGINX_VERSION}.tar.gz

WORKDIR /nginx-${NGINX_VERSION}
ARG NGINX_CONFIG_DIR=/etc/nginx
VOLUME ${NGINX_CONFIG_DIR}

RUN ./configure --prefix=/var/www/html --sbin-path=/usr/sbin/nginx --conf-path=${NGINX_CONFIG_DIR}/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-pcre  --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-http_image_filter_module=dynamic --modules-path=/etc/nginx/modules --with-http_v2_module --with-stream=dynamic --with-http_addition_module --with-http_mp4_module
RUN make
RUN make install

FROM alpine:latest

ARG NGINX_VERSION

COPY --from=builder /usr/sbin/nginx /usr/sbin/nginx
COPY --from=builder /etc/nginx /etc/nginx
COPY --from=builder /var/log/nginx /var/log/nginx
COPY --from=builder /var/www/html /var/www/html
RUN rm /etc/nginx/nginx.conf

RUN apk add --no-cache pcre zlib openssl gd libxml2 util-linux


COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]