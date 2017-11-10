

* Build Image

```
docker build --rm -t my/spark:2.2.0 .
````


* Run Image

```
docker run --rm -it -p 8088:8088 -p 8042:8042 -p 4040:4040 -h sandbox my/spark:2.2.0 bash
```

or

```
docker run -d -h sandbox my/spark:2.2.0 -d
```

* Test Hadoop

```
cd $HADOOP_PREFIX
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep input output 'dfs[a-z.]+'

bin/hdfs dfs -cat output/\*
```

* Test Spark

```
export LD_LIBRARY_PATH=$HADOOP_PREFIX/lib/native

spark-shell --master yarn --deploy-mode client \
  --driver-memory 1g --executor-memory 1g --executor-cores 1
```

try following variables in yarn-site.xml if spark-shell failed.

```
    <property> <!-- for java8 -->
      <name>yarn.nodemanager.pmem-check-enabled</name>
      <value>false</value>
    </property>
    <property> <!-- for java8 -->
      <name>yarn.nodemanager.vmem-check-enabled</name>
      <value>false</value>
    </property>
```

```
spark-submit --class org.apache.spark.examples.SparkPi \
  --master yarn --deploy-mode cluster \
  --driver-memory 1g --executor-memory 1g --executor-cores 1 \
  --queue thequeue \
  examples/jars/spark-examples\*.jar 10
```


* Debugging

following variable in yarn-site.xml helps to debug yarn failure with 'yarn logs -applicationId <appId>'

```
    <property>
      <name>yarn.log-aggregation-enable</name>
      <value>true</value>
    </property>
```

for log4j.properties,
```
log4j.logger.org.apache.spark.scheduler.cluster.YarnClientSchedulerBackend=DEBUG
log4j.logger.org.apache.hadoop=DEBUG
```



*  Original

[docker-spark](https://github.com/sequenceiq/docker-spark)
[docker-hadoop-ubuntu](https://github.com/sequenceiq/docker-hadoop-ubuntu)


