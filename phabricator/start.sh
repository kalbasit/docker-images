#!/bin/sh

# Start the ssh server
mkdir -p /usr/libexec /var/run/sshd
/usr/sbin/sshd

# Start the daemons
su -s /bin/sh -c '/opt/phabricator/bin/phd start' www-data

# Start apache2
exec bash -c "source /etc/apache2/envvars; /usr/sbin/apache2 -DFOREGROUND"
