FROM alpine

RUN apk add --update-cache git openssh-client \
  && rm -rf /var/cache/apk/*

COPY sync /usr/bin/sync
COPY sshconfig /root/.ssh/config

VOLUME /data

CMD ["sync"]
