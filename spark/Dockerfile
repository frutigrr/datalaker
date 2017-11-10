#FROM sequenceiq/hadoop-ubuntu:2.6.0
FROM my/hadoop:2.6.0
MAINTAINER hayato

ENV JAVA_VER 8u151
ENV JAVA_BUILD b12
ENV JAVA_VER_BUILD $JAVA_VER-$JAVA_BUILD
ENV JAVA_URL_KEY /e758a0de34e24606bca991d704f6dcbf
RUN mkdir -p /usr/java/default && \
    curl -Ls "http://download.oracle.com/otn-pub/java/jdk/${JAVA_VER_BUILD}${JAVA_URL_KEY}/jdk-${JAVA_VER}-linux-x64.tar.gz" -H 'Cookie: gpw_e24=xxx; oraclelicense=accept-securebackup-cookie;' | \
    tar --strip-components=1 -xz -C /usr/java/default/

#support for Hadoop 2.6.0
ENV SPARK_DOWNLOAD_URL http://archive.apache.org/dist/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.6.tgz
#ENV SPARK_DOWNLOAD_URL http://ftp.kddilabs.jp/infosystems/apache/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.6.tgz
#ENV SPARK_DOWNLOAD_URL http://ftp.jaist.ac.jp/pub/apache/spark/spark-2.2.0/spark-2.2.0-bin-hadoop2.6.tgz
RUN curl -s $SPARK_DOWNLOAD_URL | tar -xz -C /usr/local/
RUN cd /usr/local && ln -s spark-2.2.0-bin-hadoop2.6 spark
ENV SPARK_HOME /usr/local/spark
RUN mkdir $SPARK_HOME/yarn-remote-client
ADD yarn-remote-client $SPARK_HOME/yarn-remote-client
COPY log4j.properties $SPARK_HOME/conf/log4j.properties


RUN $BOOTSTRAP && $HADOOP_PREFIX/bin/hadoop dfsadmin -safemode leave && $HADOOP_PREFIX/bin/hdfs dfs -put $SPARK_HOME-2.2.0-bin-hadoop2.6/jars /spark

ENV YARN_CONF_DIR $HADOOP_PREFIX/etc/hadoop
ENV PATH $PATH:$SPARK_HOME/bin:$HADOOP_PREFIX/bin
# update boot script
COPY bootstrap.sh /etc/bootstrap.sh
RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

#install R
RUN apt-get update && \
    apt-get install -y r-base python python-dev python-pip libssl-dev git make locate vim && \
    apt-get autoremove -y && \
    apt-get clean && \
    /usr/bin/updatedb

ENTRYPOINT ["/etc/bootstrap.sh"]
