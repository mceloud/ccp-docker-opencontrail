FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-config-openstack ifmap-server && \
    cp /usr/share/doc/contrail-config/examples/contrail-config-nodemgr.ini /etc/contrail/supervisord_config_files/ && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8082 8081 8443
