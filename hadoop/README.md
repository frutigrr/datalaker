

* Build Image

```
docker build --rm -t my/hadoop:2.6.0 .
```


* Run Image

```
docker run --rm -it -h sandbox my/hadoop:2.6.0 /etc/bootstrap.sh -bash
```


* Test Hadoop

```
cd $HADOOP_PREFIX
bin/hadoop jar share/hadoop/mapreduce/hadoop-mapreduce-examples-2.6.0.jar grep input output 'dfs[a-z.]+'

bin/hdfs dfs -cat output/\*
```
```
bin/yarn jar share/hadoop/mapreduce/hadoop-mapreduce-examples\*.jar pi 16 1000
```



*  Original

[docker-spark](https://github.com/sequenceiq/docker-spark)
[docker-hadoop-ubuntu](https://github.com/sequenceiq/docker-hadoop-ubuntu)


