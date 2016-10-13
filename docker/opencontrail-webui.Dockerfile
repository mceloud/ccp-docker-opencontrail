FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-web-controller nodejs-legacy && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files/entrypoint.sh.webui /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /var/lib/contrail-webui/contrail-web-core
RUN chmod +x /entrypoint.sh

EXPOSE 8143
