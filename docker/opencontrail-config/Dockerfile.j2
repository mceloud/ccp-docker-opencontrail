FROM {{ image_spec("opencontrail-base") }}

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-config-openstack ifmap-server && \
    mkdir /var/crashes -p && \
    cp /usr/share/doc/contrail-config/examples/contrail-config-nodemgr.ini /etc/contrail/supervisord_config_files/ && \
    sed -i "s,--conf_file /etc/contrail/contrail-api.conf --conf_file /etc/contrail/contrail-keystone-auth.conf,--conf_file /var/lib/contrail/contrail-api.conf --conf_file /var/lib/contrail/contrail-keystone-auth.conf,g" /etc/contrail/supervisord_config_files/contrail-api.ini && \
    sed -i "s,/etc/contrail/contrail-schema.conf,/var/lib/contrail/contrail-schema.conf,g" /etc/contrail/supervisord_config_files/contrail-schema.ini && \
    sed -i "s,/usr/bin/contrail-svc-monitor,/usr/bin/contrail-svc-monitor --conf_file /var/lib/contrail/contrail-svc-monitor.conf,g" /etc/contrail/supervisord_config_files/contrail-svc-monitor.ini && \
    sed -i "s,/etc/contrail/contrail-keystone-auth.conf,/var/lib/contrail/contrail-keystone-auth.conf,g" /etc/contrail/supervisord_config_files/contrail-device-manager.ini && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8082 8081 8443
