FROM alpine
MAINTAINER Wael Nasreddine <wael.nasreddine@gmail.com>

ARG TASKDDATA=/var/taskd
ARG LIBUUID_VERSION=1.0.3
ARG TASKD_VERSION=1.1.0

RUN apk add --update build-base \
                     cmake \
                     gnutls \
                     gnutls-dev \
                     libstdc++ \
    && wget -O- http://downloads.sourceforge.net/project/libuuid/libuuid-${LIBUUID_VERSION}.tar.gz | tar xz \
        && cd libuuid-${LIBUUID_VERSION} \
        && ./configure --prefix=/usr \
        && make install \
        && cd .. \
        && rm -rf libuuid-${LIBUUID_VERSION} \
    && wget -O- http://taskwarrior.org/download/taskd-${TASKD_VERSION}.tar.gz | tar xz \
        && cd taskd-${TASKD_VERSION} \
        && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=release . \
        && make install \
        && cd .. \
        && rm -rf taskd-${TASKD_VERSION} \
    && apk del --purge build-base \
                       cmake \
                       gnutls-dev \
    && rm -rf /var/cache/apk/*

ADD ./taskserver.sh /usr/local/bin/taskserver

VOLUME $TASKDDATA
EXPOSE 53589

CMD ["taskserver"]
