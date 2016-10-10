FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y cassandra contrail-database openjdk-7-jre-headless && \
    mkdir /var/lib/contrail/supervisord_database_files -p && \
    cp /etc/contrail/supervisord_database_files/* /var/lib/contrail/supervisord_database_files/ && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9160 2181 9092 9042