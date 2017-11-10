
FROM ubuntu:16.04
MAINTAINER hayato

USER root

# install dev tools
RUN apt-get update && \
    apt-get install -y curl tar sudo openssh-server openssh-client rsync locate && \
    apt-get autoremove -y && \
    apt-get clean && \
    /usr/bin/updatedb

# passwordless ssh
RUN rm -f /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_rsa_key /root/.ssh/id_rsa
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys


# install java
ENV JAVA_VER 8u151
ENV JAVA_BUILD b12
ENV JAVA_VER_BUILD $JAVA_VER-$JAVA_BUILD
ENV JAVA_URL_KEY /e758a0de34e24606bca991d704f6dcbf
RUN mkdir -p /usr/java/default && \
    curl -Ls "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VER_BUILD}${JAVA_URL_KEY}/jdk-${JAVA_VER}-linux-x64.tar.gz" -H 'Cookie: gpw_e24=xxx; oraclelicense=accept-securebackup-cookie;' | \
    tar --strip-components=1 -xz -C /usr/java/default/

ENV JAVA_HOME /usr/java/default/
ENV PATH $PATH:$JAVA_HOME/bin

# install hadoop
RUN curl -s http://archive.apache.org/dist/hadoop/common/hadoop-2.6.0/hadoop-2.6.0.tar.gz | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s ./hadoop-2.6.0 hadoop

ENV HADOOP_PREFIX /usr/local/hadoop
ENV HADOOP_HOME $HADOOP_PREFIX
RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/java/default\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
#RUN . $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

# pseudo distributed
ADD core-site.xml.template $HADOOP_PREFIX/etc/hadoop/core-site.xml.template
RUN sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
ADD hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml

ADD mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

# format HDFS
RUN $HADOOP_PREFIX/bin/hdfs namenode -format

# fixing the libhadoop.so due to no amd64 version included in dist
RUN rm  /usr/local/hadoop/lib/native/*
RUN curl -Ls http://dl.bintray.com/sequenceiq/sequenceiq-bin/hadoop-native-64-2.6.0.tar|tar -x -C /usr/local/hadoop/lib/native/
RUN echo /usr/local/hadoop/lib/native > /etc/ld.so.conf.d/hadoop.conf

ADD ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# # installing supervisord
# RUN apt-get install -y python-dev python-pip supervisor
# RUN pip install -U pip setuptools wheel
# RUN pip install supervisor
# ADD supervisord.conf /etc/supervisord.conf

ADD bootstrap.sh /etc/bootstrap.sh
RUN chown root:root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

ENV BOOTSTRAP /etc/bootstrap.sh

# workingaround docker.io build error
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh
RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh
RUN ls -la /usr/local/hadoop/etc/hadoop/*-env.sh

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config


RUN service ssh start && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh && \
  $HADOOP_PREFIX/sbin/start-dfs.sh && \
  $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root && \
  $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p input && \
  $HADOOP_PREFIX/bin/hdfs dfs -put $HADOOP_PREFIX/etc/hadoop/ input

CMD ["/etc/bootstrap.sh", "-d"]

EXPOSE 50020 50090 50070 50010 50075 8031 8032 8033 8040 8042 49707 22 8088 8030

