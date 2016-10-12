FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-control contrail-dns && \
    mkdir /var/lib/contrail/supervisord_control_files -p && \
    cp /etc/contrail/supervisord_control_files/* /var/lib/contrail/supervisord_control_files/ && \
    cp /usr/share/doc/contrail-control/examples/contrail-control-nodemgr.ini /var/lib/contrail/supervisord_control_files/ && \
    sed -i "s,/usr/bin/contrail-control,/usr/bin/contrail-control --conf_file /var/lib/contrail/contrail-control.conf,g" /var/lib/contrail/supervisord_control_files/contrail-control.ini && \
    sed -i "s,/usr/bin/contrail-dns,/usr/bin/contrail-dns --conf_file /var/lib/contrail/contrail-dns.conf,g" /var/lib/contrail/supervisord_control_files/contrail-dns.ini && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8083 53