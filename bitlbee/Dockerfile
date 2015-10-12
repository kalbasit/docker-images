FROM alpine

RUN apk add --update-cache bitlbee \
  && rm -rf /var/cache/apk/*

RUN addgroup bitlbee && \
  adduser -D -H -h /var/lib/bitlbee -s /bin/sh -G bitlbee bitlbee

COPY entrypoint.sh /sbin/entrypoint
COPY bitlbee.conf /etc/bitlbee/bitlbee.conf
VOLUME /var/lib/bitlbee

EXPOSE 6667
ENTRYPOINT ["/sbin/entrypoint"]
CMD ["bitlbee", "-n"]
