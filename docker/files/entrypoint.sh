#!/bin/sh -e

if [ "$ROLE" = "analyticsdb" ]; then
    mkdir -p /var/lib/cassandra/data /var/lib/cassandra/commitlog /var/lib/cassandra/saved_caches /var/lib/zookeeper/version-2
    chown cassandra:cassandra /var/lib/cassandra/* -R
fi

if [ "$ROLE" = "controller" ]; then
    mkdir -p /var/lib/cassandra/data /var/lib/cassandra/commitlog /var/lib/cassandra/saved_caches /var/lib/zookeeper/version-2
    chown cassandra:cassandra /var/lib/cassandra/* -R
fi

exec /lib/systemd/systemd systemd.unit=multi-user.target
