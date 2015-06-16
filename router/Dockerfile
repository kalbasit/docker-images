FROM alpine:3.1

# install common packages
RUN apk add --update-cache curl bash sudo

ADD build.sh /sbin/build-router.sh
ADD nginx.conf /opt/nginx.conf

RUN /sbin/build-router.sh \
  && rm -rf /tmp/build \
  && rm -rf /var/cache/apk/*

VOLUME /opt/nginx/conf/sites
VOLUME /opt/nginx/conf/streams
EXPOSE 22 80 443

CMD ["/opt/nginx/sbin/nginx", "-c", "/opt/nginx/conf/nginx.conf"]
