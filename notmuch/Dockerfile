FROM alpine

ARG NOTMUCH_VERSION=0.24.2

COPY notmuch_new_loop /usr/bin/notmuch_new_loop

RUN apk add --update --no-cache curl git make gcc g++ zlib xapian-core-dev gmime-dev talloc-dev \
  && curl -Lo notmuch.tar.gz https://github.com/notmuch/notmuch/archive/${NOTMUCH_VERSION}.tar.gz \
  && tar -xzf notmuch.tar.gz \
  && cd notmuch-${NOTMUCH_VERSION} \
  && ./configure --prefix=/usr \
  && make install \
  && rm -rf ../notmuch.tar.gz ../notmuch-${NOTMUCH_VERSION} \
  && curl -Lo /usr/bin/nottoomuch-addresses https://raw.githubusercontent.com/domo141/nottoomuch/master/nottoomuch-addresses.sh \
  && chmod 755 /usr/bin/nottoomuch-addresses

CMD ["/usr/bin/notmuch_new_loop"]
