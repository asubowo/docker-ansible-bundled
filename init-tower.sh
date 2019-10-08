#!/bin/bash

trap "kill -15 -1 && echo Stopping Tower..." TERM KILL INT

## On init, copy certs and tower license if applicable 
if [[ -f /license_and_certs/tower.cert -a -f /license_and_certs/tower.key ]]; then
    echo "Updating certs"
    cp /license_and_certs/tower.cert /etc/tower/tower.cert
    cp /license_and_certs/tower.key /etc/tower/tower.key
    chown -R awx:awx /etc/tower/*
fi

if [[ -f /license_and_certs/license ]]; then
    echo "Updating license"
    cp /license_and_certs/license /etc/tower/license
    chown awx:awx /etc/tower/license
fi

ansible-tower-service start
sleep inf & wait