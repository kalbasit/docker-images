#!/bin/sh

# Start the daemons
su -s /bin/sh -c '/opt/phabricator/bin/phd start' www-data

# Start apache2
exec bash -c "source /etc/apache2/envvars; /usr/sbin/apache2 -DFOREGROUND"
