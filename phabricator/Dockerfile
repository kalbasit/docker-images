FROM debian:jessie
MAINTAINER  Wael Nasreddine <wael.nasreddine@gmail.com>

ENV DEBIAN_FRONTEND=noninteractive \
  DEBCONF_NONINTERACTIVE_SEEN=true \
  PHABRICATOR_USER=kalbasit \
  PHABRICATOR_COMMIT=61fcfc8de8980c5bc35bebfb6510fa431b601083 \
  ARCANIST_COMMIT=807057087d65298e69bb8260db81bee1ae109084 \
  LIBPHUTIL_COMMIT=6c0118085afdc6c6802849cac363efbc76def972

RUN apt-get update && apt-get install -y build-essential git apache2 curl libapache2-mod-php5 \
        libmysqlclient18 mercurial mysql-client php-apc php5 php5-apcu php5-cli \
        php5-curl php5-gd php5-json php5-ldap php5-mysql python-pygments \
        sendmail subversion tar sudo openssh-server \
      && apt-get clean && rm -rf /var/lib/apt/lists/* \
      && rm -f /etc/ssh/ssh_host_* \
      && ln -s /usr/lib/git-core/git-http-backend /usr/bin/git-http-backend \
      && curl -L https://github.com/${PHABRICATOR_USER}/phabricator/archive/${PHABRICATOR_COMMIT}.tar.gz | tar -xzf - \
      && mv phabricator-${PHABRICATOR_COMMIT} /opt/phabricator \
      && curl -L https://github.com/phacility/arcanist/archive/${ARCANIST_COMMIT}.tar.gz | tar -xzf - \
      && mv arcanist-${ARCANIST_COMMIT} /opt/arcanist \
      && curl -L https://github.com/phacility/libphutil/archive/${LIBPHUTIL_COMMIT}.tar.gz | tar -xzf - \
      && mv libphutil-${LIBPHUTIL_COMMIT} /opt/libphutil \
      && /opt/libphutil/scripts/build_xhpast.php \
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
      && echo 'git ALL=(www-data) SETENV: NOPASSWD: /usr/bin/git-upload-pack, /usr/bin/git-receive-pack, /usr/bin/hg, /usr/bin/svnserve' >> /etc/sudoers \
      && apt-get remove -y build-essential \
      && apt-get autoremove -y

ADD start.sh /usr/bin/start_server
ADD phabricator.conf /etc/apache2/sites-available/phabricator.conf
ADD sshd_config /etc/ssh/sshd_config
ADD ssh-hook.sh /usr/libexec/phabricator-ssh-hook.sh

EXPOSE  80 22
WORKDIR /opt/phabricator
VOLUME  ["/opt/phabricator/conf/local", "/var/repo", "/etc/ssh/keys"]
CMD     ["/usr/bin/start_server"]
