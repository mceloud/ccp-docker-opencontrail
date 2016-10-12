FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y cassandra python-yaml contrail-database openjdk-7-jre-headless && \
    sed -i "s,/usr/share/kafka/config/,/var/lib/contrail/,g" /etc/contrail/supervisord_database_files/kafka.ini && \
    sed -i 's,command=cassandra,command=cassandra\ \-D\ cassandra.config=/var/lib/contrail/cassandra.yaml,g' /etc/contrail/supervisord_database.conf \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9160 2181 9092 9042