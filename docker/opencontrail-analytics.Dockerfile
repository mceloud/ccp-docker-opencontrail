FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-analytics && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export PS1='\[\e]0;\u@\h(analytics): \w\a\]${debian_chroot:+($debian_chroot)}\u@\h(analytics):\w\$ '" >> /root/.bashrc

EXPOSE 8081 5995 8181 9081 8090 8104 8086 8089 4739 6343 8081 5920 5921
