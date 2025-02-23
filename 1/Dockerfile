FROM alpine/git:v2.47.2

ARG NGINX_VERSION

RUN apk upgrade --no-cache

RUN apk add --no-cache wget build-base pcre pcre-dev zlib zlib-dev openssl-dev gd-dev libxml2 libxml2-dev util-linux-dev

RUN wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar -zxvf nginx-${NGINX_VERSION}.tar.gz -C /

WORKDIR /nginx-${NGINX_VERSION}
ARG NGINX_CONFIG_DIR=/etc/nginx
VOLUME ${NGINX_CONFIG_DIR}

RUN ./configure --prefix=/var/www/html --sbin-path=/usr/sbin/nginx --conf-path=${NGINX_CONFIG_DIR}/nginx.conf --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --with-pcre  --lock-path=/var/lock/nginx.lock --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-http_image_filter_module=dynamic --modules-path=/etc/nginx/modules --with-http_v2_module --with-stream=dynamic --with-http_addition_module --with-http_mp4_module
RUN make
RUN make install

RUN rm /etc/nginx/nginx.conf
COPY ./entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]