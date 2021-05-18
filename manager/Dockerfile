FROM registry.cn-shanghai.aliyuncs.com/huanjutang/centos:7.9.2009-v1
WORKDIR /opt/
#ADD https://github.com/alibaba/otter/releases/download/otter-4.2.18/manager.deployer-4.2.18.tar.gz /opt
ADD manager.deployer-4.2.18.tar.gz /opt
RUN rm -rf /opt/manager.deployer-4.2.18.tar.gz

#    echo "export JAVA_HOME=/usr/java/latest" >> /etc/profile && \
#    echo "export PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile
#env DOWNLOAD_LINK="http://download.oracle.com/otn-pub/java/jdk/8u181-b13/96a7b8442fe848ef90c96a2fad6ed6d1/jdk-8u181-linux-x64.rpm"
# install system
RUN \
    yum install -y which && \
    yum install -y wget && \
    yum install -y file && \
    yum install -y java-1.8.0-openjdk-1.8.0.282.b08 && \
    #    wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=xxx; oraclelicense=accept-securebackup-cookie" "$DOWNLOAD_LINK" -O /tmp/jdk-8-linux-x64.rpm && \
    #    yum -y install /tmp/jdk-8-linux-x64.rpm && \
    #    /bin/rm -f /tmp/jdk-8-linux-x64.rpm && \
    yum clean all

COPY ./start_manager.sh bin/startup.sh
CMD ["bin/startup.sh"]