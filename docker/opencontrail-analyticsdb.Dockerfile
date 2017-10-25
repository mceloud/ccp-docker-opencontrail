FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y openjdk-8-jre contrail-database-common contrail-openstack-database zookeeper && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export PS1='\[\e]0;\u@\h(analyticsdb): \w\a\]${debian_chroot:+($debian_chroot)}\u@\h(analyticsdb):\w\$ '" >> /root/.bashrc

ENV ROLE analyticsdb

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 9160 9092 8103 9042
