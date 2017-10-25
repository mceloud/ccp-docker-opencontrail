FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y  contrail-vrouter-agent contrail-vrouter-dkms && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export PS1='\[\e]0;\u@\h(agent): \w\a\]${debian_chroot:+($debian_chroot)}\u@\h(agent):\w\$ '" >> /root/.bashrc

EXPOSE 8085 9090
