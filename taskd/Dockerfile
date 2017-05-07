FROM alpine
MAINTAINER Wael Nasreddine <wael.nasreddine@gmail.com>

ENV TASKDDATA /var/taskd
ARG LIBUUID_VERSION=1.0.3
ARG TASKD_VERSION=1.1.0

RUN apk add --update build-base \
                     cmake \
                     gnutls \
                     gnutls-dev \
                     libstdc++ \
                     curl \
    && curl -L https://downloads.sourceforge.net/project/libuuid/libuuid-${LIBUUID_VERSION}.tar.gz | tar xz \
        && cd libuuid-${LIBUUID_VERSION} \
        && ./configure --prefix=/usr \
        && make install \
        && cd .. \
        && rm -rf libuuid-${LIBUUID_VERSION} \
    && curl -L https://taskwarrior.org/download/taskd-${TASKD_VERSION}.tar.gz | tar xz \
        && cd taskd-${TASKD_VERSION} \
        && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_BUILD_TYPE=release . \
        && make install \
        && cd .. \
        && rm -rf taskd-${TASKD_VERSION} \
    && apk del --purge build-base \
                       cmake \
                       gnutls-dev \
                       curl \
    && rm -rf /var/cache/apk/* \
    && addgroup -g 53589 taskd \
    && adduser -u 53589 -G taskd -D taskd

ADD ./taskserver.sh /usr/local/bin/taskserver

VOLUME $TASKDDATA
EXPOSE 53589

USER taskd

CMD ["taskserver"]
