FROM ubuntu:xenial

ARG opencontrail_version=4
ARG artifactory_url
ARG timestamp
ARG repo_url="http://apt.mirantis.com/xenial nightly oc40"
ARG repo_key="http://apt.mirantis.com/public.gpg"

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
        curl -ss http://apt.mirantis.com/public.gpg | apt-key add - && \
        curl -ss http://mirror.fuel-infra.org/mcp-repos/ocata/xenial/archive-mcpocata.key | apt-key add - && \
        curl -ss curl https://www.apache.org/dist/cassandra/KEYS | apt-key add - && \
        echo "deb [arch=amd64] http://apt.mirantis.com/xenial nightly extra ocata" > /etc/apt/sources.list.d/mcp.list && \
        echo "deb http://www.apache.org/dist/cassandra/debian/ 22x main" > /etc/apt/sources.list.d/cassandra.list && \
        echo "deb [arch=amd64] http://mirror.fuel-infra.org/mcp-repos/ocata/xenial ocata ocata-security ocata-updates ocata-hotfix ocata-holdback  main" > /etc/apt/sources.list.d/mirantis_openstack.list && \
        curl -ss "${REPO_KEY}" | apt-key add - && \
        echo "deb [arch=amd64] ${REPO_URL}" > /etc/apt/sources.list.d/opencontrail.list \
    ;else \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y apt-transport-https curl && \
        echo | openssl s_client -showcerts -connect `echo $ARTIFACTORY_URL | cut -d '/' -f 3` 2>/dev/null | awk '/BEGIN CERTIFICATE/{print;flag=1;next}/END CERTIFICATE/{print;flag=0}flag' >/usr/local/share/ca-certificates/artifactory.crt && \
        update-ca-certificates && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} xenial main restricted" >/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} xenial universe" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} xenial-updates main restricted" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} xenial-updates universe" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} xenial-security main restricted" >>/etc/apt/sources.list && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-${TIMESTAMP} xenial-security universe" >>/etc/apt/sources.list && \
        curl -ss --insecure "${ARTIFACTORY_URL}/in-ubuntu-oc40/public.gpg" | apt-key add - && \
        echo "deb ${ARTIFACTORY_URL}/in-ubuntu-oc40-${TIMESTAMP}/nightly xenial oc30 extra tcp" >>/etc/apt/sources.list \
    ;fi; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get -y install python-yaml gettext-base contrail-utils contrail-nodemgr && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#COPY files/entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh
RUN cd /lib/systemd/system/sysinit.target.wants/; ls | grep -v systemd-tmpfiles-setup | xargs rm -f $1 \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*; \
rm -f /lib/systemd/system/plymouth*; \
rm -f /lib/systemd/system/systemd-update-utmp*;
RUN systemctl set-default multi-user.target
COPY files/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV init /lib/systemd/systemd
#ENTRYPOINT ["/lib/systemd/systemd"]
#CMD ["systemd.unit=multi-user.target"]