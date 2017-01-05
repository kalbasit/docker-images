FROM alpine:3.5

RUN apk add --update gcc g++ git make py-virtualenv python2-dev sqlite-dev postgresql postgresql-dev \
  && rm -rf /var/cache/apk

ARG ffsync_version=1.6.0

RUN git clone --branch="${ffsync_version}" https://github.com/mozilla-services/syncserver.git /opt/syncserver \
  && cd /opt/syncserver \
  && make \
  && ./local/bin/pip install PyMySQL \
  && ./local/bin/pip install pysqlite \
  && ./local/bin/pip install psycopg2

WORKDIR /opt/syncserver
EXPOSE 5000
CMD ["/opt/syncserver/local/bin/gunicorn", "--paste", "/etc/syncserver.ini"]
