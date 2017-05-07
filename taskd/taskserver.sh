#!/usr/bin/env bash
set -e

if [[ ! -f "${TASKDDATA}/config" ]]; then
  taskd init \
    && taskd config --force client.cert "${TASKDDATA}/client.cert.pem" \
    && taskd config --force client.key "${TASKDDATA}/client.key.pem" \
    && taskd config --force server.cert "${TASKDDATA}/server.cert.pem" \
    && taskd config --force server.key "${TASKDDATA}/server.key.pem" \
    && taskd config --force server.crl "${TASKDDATA}/server.crl.pem" \
    && taskd config --force ca.cert "${TASKDDATA}/ca.cert.pem" \
    && taskd config --force log /dev/stdout \
    && taskd config --force pid.file /run/taskd.pid \
    && taskd config --force server 0.0.0.0:53589
fi

exec taskd server
