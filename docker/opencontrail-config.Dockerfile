FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-config-openstack ifmap-server && \
    cp /usr/share/doc/contrail-config/examples/contrail-config-nodemgr.ini /etc/contrail/supervisord_config_files/ && \
    sed -i "s,/usr/bin/contrail-api,/usr/bin/contrail-api --conf_file /var/lib/contrail/contrail-api.conf,g" /etc/contrail/supervisord_config_files/contrail-api.ini && \
    sed -i "s,/usr/bin/contrail-schema,/usr/bin/contrail-schema --conf_file /var/lib/contrail/contrail-schema.conf,g" /etc/contrail/supervisord_config_files/contrail-schema.ini && \
    sed -i "s,/usr/bin/contrail-svc-monitor,/usr/bin/contrail-svc-monitor --conf_file /var/lib/contrail/contrail-svc-monitor.conf,g" /etc/contrail/supervisord_config_files/contrail-svc-monitor.ini && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8082 8081 8443
