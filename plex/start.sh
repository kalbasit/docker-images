#!/bin/bash -x

mkdir -p /config/logs/supervisor

touch /supervisord.log
touch /supervisord.pid
chown plex: /supervisord.log /supervisord.pid

# remove previous pid if it exists
rm /config/Library/Application\ Support/Plex\ Media\ Server/plexmediaserver.pid

# Current defaults to run as root while testing.
sudo -u plex -E sh -c "/usr/sbin/start_pms"
