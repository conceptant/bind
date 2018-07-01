#!/bin/sh
if [ ! -f /etc/bind/named.conf ]; then
    mkdir -p /var/named
    chown -R named /var/named
    cp -a etc_bind/* /etc/bind
fi

named -c /etc/bind/named.conf -g -u named