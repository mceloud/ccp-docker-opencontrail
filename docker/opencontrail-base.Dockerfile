FROM ubuntu:trusty

ARG opencontrail_version=3
ARG artifactory_url
ARG timestamp

ENV OPENCONTRAIL_VERSION $opencontrail_version
ENV ARTIFACTORY_URL $artifactory_url
ENV TIMESTAMP $timestamp

## Configure APT mirror
# TODO: remove this while building from customized image with
# apt-transport-https and curl already installed
RUN if [ -z "${ARTIFACTORY_URL}" ]; then \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y curl && \
        curl -ss http://apt.tcpcloud.eu/public.gpg | apt-key add - && \
        echo "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty oc30 extra tcp" > /etc/apt/sources.list.d/opencontrail.list \
    ;else \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https curl && \
        echo | openssl s_client -showcerts -connect `echo $ARTIFACTORY_URL | cut -d '/' -f 3` 2>/dev/null | awk '/BEGIN CERTIFICATE/{print;flag=1;next}/END CERTIFICATE/{print;flag=0}flag' >/usr/local/share/ca-certificates/artifactory.crt && \
        update-ca-certificates && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} trusty main restricted" >/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} trusty universe" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} trusty-updates main restricted" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} trusty-updates universe" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} trusty-security main restricted" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} trusty-security universe" >>/etc/apt/sources.list && \
        curl -ss --insecure "${ARTIFACTORY_URL}/in-ubuntu-oc30/public.gpg" | apt-key add - && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-oc30-${TIMESTAMP}/nightly trusty oc30 extra tcp" >>/etc/apt/sources.list \
    ;fi; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get -y install curl python-yaml gettext-base contrail-utils contrail-nodemgr netcat lvm2 open-iscsi tgt vim less patch gcc python-dev && \
     curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
     python get-pip.py && \
     rm get-pip.py && \
     pip install --no-cache-dir -r https://raw.githubusercontent.com/openstack/fuel-ccp-debian-base/master/docker/base-tools/requirements.txt && \
     apt-get -y purge gcc python-dev && apt-get -y autoremove && apt-get clean && \
     rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh