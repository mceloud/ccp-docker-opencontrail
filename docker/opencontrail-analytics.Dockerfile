FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-analytics python-cassandra && \
    mkdir /var/lib/contrail/supervisord_analytics_files -p && \
    cp /etc/contrail/supervisord_analytics_files/* /var/lib/contrail/supervisord_analytics_files/ && \
    cp /usr/share/doc/contrail-analytics/examples/contrail-analytics-nodemgr.ini /var/lib/contrail/supervisord_analytics_files/ && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8081