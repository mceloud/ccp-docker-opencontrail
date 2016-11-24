FROM {{ image_spec("opencontrail-base") }}

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y redis-server && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/redis-server"]

EXPOSE 6379