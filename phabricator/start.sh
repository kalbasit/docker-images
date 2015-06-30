#!/bin/sh

# Copy the JSON data if available as an environment variable
if [ -n "${LOCAL_JSON}" ]; then
  echo "${LOCAL_JSON}" | python -m json.tool > /tmp/local.json
  if [ $? -ne 0 ]; then
    echo "LOCAL_JSON is not a valid json"
    exit 1
  fi

  mv /tmp/local.json /opt/phabricator/conf/local/local.json
  chown www-data: /opt/phabricator/conf/local/local.json
fi

# Generate the SSH key if one is not present
if [ ! -f "/etc/ssh/keys/ssh_host_rsa_key" ]; then
  echo "Creating SSH2 RSA key; this may take some time ..."
  ssh-keygen -q -f /etc/ssh/keys/ssh_host_rsa_key -N '' -t rsa
  ssh-keygen -l -f /etc/ssh/keys/ssh_host_rsa_key.pub
fi

# Start the ssh server
mkdir -p /usr/libexec /var/run/sshd
/usr/sbin/sshd

# Start the daemons
su -s /bin/sh -c '/opt/phabricator/bin/phd start' www-data

# Start apache2
exec bash -c "source /etc/apache2/envvars; /usr/sbin/apache2 -DFOREGROUND"
