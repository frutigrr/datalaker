#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:$HADOOP_PREFIX/lib/native"
export HADOOP_HOME=$HADOOP_PREFIX

$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

# setting spark 1.x defaults
#echo spark.yarn.jar hdfs:///spark/spark-assembly-1.6.0-hadoop2.6.0.jar > $SPARK_HOME/conf/spark-defaults.conf
echo spark.yarn.archive hdfs:///spark > $SPARK_HOME/conf/spark-defaults.conf
echo spark.yarn.jars hdfs:///spark/* >> $SPARK_HOME/conf/spark-defaults.conf
echo spark.yarn.shuffle.stopOnFailure false >> $SPARK_HOME/conf/spark-defaults.conf
cp $SPARK_HOME/conf/metrics.properties.template $SPARK_HOME/conf/metrics.properties

service ssh start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh



CMD=${1:-"exit 0"}
if [[ "$CMD" == "-d" ]];
then
    service ssh stop
    /usr/sbin/sshd -D -d
else
    /bin/bash -c "$*"
fi

