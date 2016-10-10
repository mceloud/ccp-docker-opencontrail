FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get -y contrail-config-openstack ifmap-server && \
    mkdir /var/lib/contrail/supervisord_config_files -p && \
    cp /etc/contrail/supervisord_config_files/* /var/lib/contrail/supervisord_config_files/ && \
    cp /usr/share/doc/contrail-config/examples/contrail-config-nodemgr.ini /var/lib/contrail/supervisord_config_files/ && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8082 8081 8443
