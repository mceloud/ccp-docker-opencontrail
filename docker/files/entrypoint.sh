#!/bin/sh -e

[ -z "$1" ] && (echo "Usage: $0 <component>" 1>&2; exit 1)

if [ "$2" == "check" ]; then
    su nova -s /bin/sh -c "/usr/bin/opencontrail-check"
    exit $?
fi

echo "Symlink for supervisord_$1.conf files"
ln -s /var/lib/contrail/supervisord_$1_files/* /etc/contrail/supervisord_$1_files/

echo "Starting opencontrail-$1"
/usr/bin/supervisord --nodaemon -c /etc/contrail/supervisord_$1.conf