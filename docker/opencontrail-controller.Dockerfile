FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-control contrail-dns contrail-config-openstack contrail-config contrail-database-common openjdk-8-jre contrail-web-core contrail-web-controller rabbitmq-server=3.5.7-1ubuntu0.16.04.2 gettext-base zookeeper && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export PS1='\[\e]0;\u@\h(controller): \w\a\]${debian_chroot:+($debian_chroot)}\u@\h(controller):\w\$ '" >> /root/.bashrc

ENV ROLE controller

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 8084 8083 9042 53 8143 8083 8082 8081 8443 179 5269 8092 8093 2181 4369 5672 8100 8080 8096 8088 8087 8096 8103 9160 8094 8101
