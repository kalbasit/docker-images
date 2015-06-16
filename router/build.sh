#!/usr/bin/env bash

# fail on any command exiting non-zero
set -eo pipefail

export VERSION_NGINX=nginx-1.9.1

export BUILD_PATH=/tmp/build

# nginx installation directory
export PREFIX=/opt/nginx

rm -rf $PREFIX
mkdir -p $PREFIX

mkdir -p $BUILD_PATH
cd $BUILD_PATH

# install required packages to build
apk add build-base \
  curl \
  geoip-dev \
  libcrypto1.0 \
  libpcre32 \
  patch \
  pcre-dev \
  openssl-dev \
  zlib \
  zlib-dev

# grab the source files
curl -sSL http://nginx.org/download/$VERSION_NGINX.tar.gz -o $BUILD_PATH/$VERSION_NGINX.tar.gz

# expand the source files
tar xzf $VERSION_NGINX.tar.gz

# build nginx
cd $BUILD_PATH/$VERSION_NGINX
./configure \
  --prefix=$PREFIX \
  --pid-path=/run/nginx.pid \
  --with-debug \
  --with-pcre-jit \
  --with-ipv6 \
  --with-http_ssl_module \
  --with-http_stub_status_module \
  --with-http_realip_module \
  --with-http_auth_request_module \
  --with-http_addition_module \
  --with-http_dav_module \
  --with-http_geoip_module \
  --with-http_gzip_static_module \
  --with-http_spdy_module \
  --with-http_sub_module \
  --with-mail \
  --with-mail_ssl_module \
  --with-stream \
  && make && make install

# add nginx users
addgroup -S nginx \
  && adduser -S -G nginx -H -h /opt/nginx -s /sbin/nologin -D nginx

# replace the config with ours
mkdir -p /opt/nginx/conf/sites
mkdir -p /opt/nginx/conf/streams
cp /opt/nginx.conf /opt/nginx/conf/nginx.conf
