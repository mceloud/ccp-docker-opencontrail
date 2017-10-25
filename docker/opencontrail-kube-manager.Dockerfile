FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y contrail-kube-manager && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN echo "export PS1='\[\e]0;\u@\h(kubemanager): \w\a\]${debian_chroot:+($debian_chroot)}\u@\h(kubemanager):\w\$ '" >> /root/.bashrc
