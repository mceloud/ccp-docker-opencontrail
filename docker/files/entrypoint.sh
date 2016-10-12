#!/bin/sh -e

[ -z "$1" ] && (echo "Usage: $0 <component>" 1>&2; exit 1)

if [ "$2" == "check" ]; then
    su nova -s /bin/sh -c "/usr/bin/opencontrail-check"
    exit $?
fi

# Replace env variables for database config files
if [ "$1" == "database" ]; then
    echo "Replace env variables"
    cat /usr/share/kafka/config/server.properties | envsubst > /var/lib/contrail/server.properties
    cat /etc/cassandra/cassandra.yaml | envsubst > /var/lib/contrail/cassandra.yaml
fi

# Replace env variables for control config file
if [ "$1" == "control" ]; then
    echo "Replace env variables"
    cat /etc/contrail/contrail-control.conf | envsubst > /var/lib/contrail/contrail-control.conf
    cat /etc/contrail/contrail-dns.conf | envsubst > /var/lib/contrail/contrail-dns.conf
fi

echo "Starting opencontrail-$1"
/usr/bin/supervisord --nodaemon -c /etc/contrail/supervisord_$1.conf