#!/bin/sh -e

[ -z "$1" ] && (echo "Usage: $0 <component>" 1>&2; exit 1)

if [ "$2" = "check" ]; then
    su nova -s /bin/sh -c "/usr/bin/opencontrail-check"
    exit $?
fi

# Replace env variables for database config files
if [ "$1" = "database" ]; then
    echo "Replace env variables"
    cat /usr/share/kafka/config/server.properties | envsubst > /var/lib/contrail/server.properties
    cat /etc/cassandra/cassandra.yaml | envsubst > /var/lib/contrail/cassandra.yaml
fi

# Replace env variables for control config file
if [ "$1" = "control" ]; then
    echo "Replace env variables"
    cat /etc/contrail/contrail-control.conf | envsubst > /var/lib/contrail/contrail-control.conf
    cat /etc/contrail/contrail-dns.conf | envsubst > /var/lib/contrail/contrail-dns.conf
fi

# Replace env variables for analytics config file
if [ "$1" = "analytics" ]; then
    echo "Replace env variables"
    cat /etc/contrail/contrail-collector.conf | envsubst > /var/lib/contrail/contrail-collector.conf
    cat /etc/contrail/contrail-analytics-api.conf | envsubst > /var/lib/contrail/contrail-analytics-api.conf
    cat /etc/contrail/contrail-query-engine.conf | envsubst > /var/lib/contrail/contrail-query-engine.conf
    cat /etc/contrail/contrail-alarm-gen.conf | envsubst > /var/lib/contrail/contrail-alarm-gen.conf
    cat /etc/contrail/contrail-topology.conf | envsubst > /var/lib/contrail/contrail-topology.conf
fi

# Replace env variables for config config file
if [ "$1" = "config" ]; then
    echo "Replace env variables"
    cat /etc/contrail/contrail-api.conf | envsubst > /var/lib/contrail/contrail-api.conf
    cat /etc/contrail/contrail-schema.conf | envsubst > /var/lib/contrail/contrail-schema.conf
    cat /etc/contrail/contrail-svc-monitor.conf | envsubst > /var/lib/contrail/contrail-svc-monitor.conf
fi

# Rewrite hostname by underlay host to get persistent naming. Wil be replaced by daemonset later
if [ -z $HOST_HOSTNAME ]; then
    echo "Rewrite hostname by underlay host"
    hostname $HOST_HOSTNAME && echo $HOST_HOSTNAME > /etc/hostname
fi

echo "Starting opencontrail-$1"
/usr/bin/supervisord --nodaemon -c /etc/contrail/supervisord_$1.conf
