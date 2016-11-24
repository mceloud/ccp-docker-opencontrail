FROM {{ image_spec("opencontrail-base") }}

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y zookeeper openjdk-7-jre-headless && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY entrypoint.sh.zookeeper /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
RUN chmod +x /entrypoint.sh

EXPOSE 2181