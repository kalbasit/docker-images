#
# Docker image for running https://github.com/phacility/phabricator
#

FROM debian:jessie
MAINTAINER  Wael Nasreddine <wael.nasreddine@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
  PHABRICATOR_COMMIT=2a5cf5e1b76c7f375326e2b9eb1239b959d77138 \
  ARCANIST_COMMIT=9a7c4d87a850ba0b61f100d68f2b8765c7e7fca5 \
  LIBPHUTIL_COMMIT=3b4da3f3315328bc616e0ba6413fb441952d53c9

ADD download.sh /download.sh
RUN apt-get update && apt-get install -y git apache2 curl libapache2-mod-php5 \
        libmysqlclient18 mercurial mysql-client php-apc php5 php5-apcu php5-cli \
        php5-curl php5-gd php5-json php5-ldap php5-mysql python-pygments \
        sendmail subversion tar sudo openssh-server \
      && apt-get clean && rm -rf /var/lib/apt/lists/* \
      && /download.sh phabricator "${PHABRICATOR_COMMIT}" \
      && /download.sh arcanist    "${ARCANIST_COMMIT}" \
      && /download.sh libphutil   "${LIBPHUTIL_COMMIT}" \
      && sed -e 's/post_max_size =.*/post_max_size = 32M/' \
          -e 's/upload_max_filesize =.*/upload_max_filesize = 32M/' \
          -e 's/;opcache.validate_timestamps=.*/opcache.validate_timestamps=0/' \
          -i /etc/php5/apache2/php.ini \
      && mkdir -p /var/repo \
      && a2enmod rewrite \
      && ln -s /etc/apache2/sites-available/phabricator.conf \
          /etc/apache2/sites-enabled/phabricator.conf \
      && rm -f /etc/apache2/sites-enabled/000-default.conf \
      && chown -R www-data:www-data /opt/phabricator \
      && adduser --home /var/repo --no-create-home --disabled-password git \
      && echo 'git ALL=(www-data) SETENV: NOPASSWD: /usr/bin/git-upload-pack, /usr/bin/git-receive-pack, /usr/bin/hg, /usr/bin/svnserve' >> /etc/sudoers

ADD start.sh /usr/bin/start_server
ADD phabricator.conf /etc/apache2/sites-available/phabricator.conf
ADD sshd_config /etc/ssh/sshd_config
ADD ssh-hook.sh /usr/libexec/phabricator-ssh-hook.sh

EXPOSE  80 22
WORKDIR /opt/phabricator
VOLUME ["/opt/phabricator/conf/local", "/var/repo"]
CMD     ["/usr/bin/start_server"]
