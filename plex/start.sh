#!/bin/bash
set -ex

## assign UID/GID for plex that matches either $UID/$GID or the permissions of
## the files in /data

if [[ -n "${UID}" ]]; then
  usermod -u "${UID}" plex
fi

if [[ -n "${GID}" ]]; then
  usermod -G "${GID}" plex
else
  usermod -G "`stat -c "%g" /data`" plex
fi

## initialize supervisor

mkdir -p /config/logs/supervisor
touch /supervisord.log
touch /supervisord.pid
chown plex: /supervisord.log /supervisord.pid

## set the correct permissions on /config unless SKIP_CHOWN_CONFIG was set.

if [[ -z "${SKIP_CHOWN_CONFIG}" ]]; then
  CHANGE_CONFIG_DIR_OWNERSHIP=false
fi

if [ "${CHANGE_CONFIG_DIR_OWNERSHIP}" = true ]; then
  find /config ! -user plex -print0 | xargs -0 -I{} chown -R plex: {}
fi

# Will change all files in directory to be readable by group
if [ "${CHANGE_DIR_RIGHTS}" = true ]; then
  chgrp -R ${GROUP} /data
  chmod -R g+rX /data
fi

## remove previous pid if it exists

# Current defaults to run as root while testing.
if [ "${RUN_AS_ROOT}" = true ]; then
  rm -f ~/Library/Application\ Support/Plex\ Media\ Server/plexmediaserver.pid
  /usr/sbin/start_pms
else
  sudo -u plex -E sh -c "rm -f /config/Library/Application\ Support/Plex\ Media\ Server/plexmediaserver.pid"
  sudo -u plex -E sh -c "/usr/sbin/start_pms"
fi
