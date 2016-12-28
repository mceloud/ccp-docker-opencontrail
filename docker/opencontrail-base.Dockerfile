FROM ubuntu:trusty

ARG opencontrail_version=3
ARG artifactory_url
ARG timestamp
ARG repo_url="http://apt.tcpcloud.eu/nightly/ trusty oc30"
ARG repo_key="http://apt.tcpcloud.eu/public.gpg"

ENV OPENCONTRAIL_VERSION $opencontrail_version
ENV ARTIFACTORY_URL $artifactory_url
ENV TIMESTAMP $timestamp
ENV REPO_URL $repo_url
ENV REPO_KEY $repo_key

## Configure APT mirror
# TODO: remove this while building from customized image with
# apt-transport-https and curl already installed
RUN if [ -z "${ARTIFACTORY_URL}" ]; then \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y curl && \
        curl -ss http://apt.tcpcloud.eu/public.gpg | apt-key add - && \
        echo "deb [arch=amd64] http://apt.tcpcloud.eu/nightly/ trusty extra tcp" > /etc/apt/sources.list.d/tcpcloud.list && \
        curl -ss "${REPO_KEY}" | apt-key add - && \
        echo "deb [arch=amd64] ${REPO_URL}" > /etc/apt/sources.list.d/opencontrail.list \
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
    DEBIAN_FRONTEND=nointeractive apt-get -y install python-yaml gettext-base contrail-utils contrail-nodemgr && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
