FROM opencontrail/opencontrail-base

RUN apt-get update && \
    DEBIAN_FRONTEND=nointeractive apt-get -y zookeeper openjdk-7-jre-headless && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["/usr/bin/java", "-cp", "/etc/zookeeper/conf:/usr/share/java/jline.jar:/usr/share/java/log4j-1.2.jar:/usr/share/java/xercesImpl.jar:/usr/share/java/xmlParserAPIs.jar:/usr/share/java/netty.jar:/usr/share/java/slf4j-api.jar:/usr/share/java/slf4j-log4j12.jar:/usr/share/java/zookeeper.jar", "-Dcom.sun.management.jmxremote", "-Dcom.sun.management.jmxremote.local.only=false", "-Dzookeeper.log.dir=/var/log/zookeeper", "-Dzookeeper.root.logger=INFO,CONSOLE,ROLLINGFILE", "org.apache.zookeeper.server.quorum.QuorumPeerMain", "/etc/zookeeper/conf/zoo.cfg"]

EXPOSE 2181