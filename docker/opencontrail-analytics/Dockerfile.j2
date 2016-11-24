FROM {{ image_spec("opencontrail-base") }}

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-analytics python-cassandra && \
    cp /usr/share/doc/contrail-analytics/examples/contrail-analytics-nodemgr.ini /etc/contrail/supervisord_analytics_files/ && \
    sed -i "s,/usr/bin/contrail-collector,/usr/bin/contrail-collector --conf_file /var/lib/contrail/contrail-collector.conf,g" /etc/contrail/supervisord_analytics_files/contrail-collector.ini && \
    sed -i "s,/etc/contrail/contrail-analytics-api.conf,/var/lib/contrail/contrail-analytics-api.conf,g" /etc/contrail/supervisord_analytics_files/contrail-analytics-api.ini && \
    sed -i "s,/usr/bin/contrail-query-engine,/usr/bin/contrail-query-engine --conf_file /var/lib/contrail/contrail-query-engine.conf,g" /etc/contrail/supervisord_analytics_files/contrail-query-engine.ini && \
    sed -i "s,/etc/contrail/contrail-alarm-gen.conf,/var/lib/contrail/contrail-alarm-gen.conf,g" /etc/contrail/supervisord_analytics_files/contrail-alarm-gen.ini && \
    sed -i "s,/usr/bin/contrail-topology,/usr/bin/contrail-topology --conf_file /var/lib/contrail/contrail-topology.conf,g" /etc/contrail/supervisord_analytics_files/contrail-topology.ini && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8081
