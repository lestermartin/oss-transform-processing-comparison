# oss-transform-processing-comparison

This project is intended to house the examples used in my upcoming DevNexus [Transformation Processing Smackdown; Spark vs Hive vs Pig](http://devnexus.com/s/devnexus2017/presentations/17533) presentation.

## Setup

The following information should help you get setup to run the examples.

### Hadoop Cluster

First, you will need a Hadoop cluster with Pig, Hive and Spark properly installed.  You have multiple options, including [major distribution providers](https://martin.atlassian.net/wiki/x/HoBmAQ) as well as a RYO approach directly from http://hadoop.apache.org/.  

For myself, and since I work for Hortonworks, I'm going to leverage the [Hortonworks Sandbox](http://hortonworks.com/products/sandbox/), but again, you can use whatever Hadoop cluster you desire.  I've tested everything using the 2.5 version.

### Script Execution

All of the Pig, Hive and Spark code presented in this project should run just about everywhere.

#### Pig

I'm using the Ambari Pig View to run these scripts, but you could use Hue, Pig's Grunt shell, or put the contents in a file and run them from the CLI with the Pig executable.

I'm using `piggybank.jar` so I moved it into HDFS to make the scripts more generic from distro to distro.  For my env, I ran the following to do this.

```
hdfs dfs -put /usr/hdp/current/pig-client/lib/piggybank.jar /tmp
```

#### Hive

I'm using the Ambari Hive View to run these scripts, but you could use Hue, the old school Hive CLI or the newer Beeline, as well as from a notebook like Zeppelin.

##### Spark

I'm using [Zeppelin](http://zeppelin.apache.org/) (included with the Hortonworks Sandbox), but you could use another web notebook as well as the Spark shell. 

### Data Set

Many of the examples leverage a select dataset based on the [FAA's Aviation Data & Statistics](https://www.faa.gov/data_research/aviation_data_statistics/) offering.  Specifically, I'm focusing on the 2008 data than can be found at [faa-data.zip](https://www.dropbox.com/s/tpl4qmfq48ivwuh/faa-data.zip?dl=0) (~40MB).

You'll need to get those data files into HDFS in some way.  For me, I did the following activities on the Sandbox.

#### Prepare a Shared Folder

I switched to the `hdfs` super-user and created a base folder to hold everything and made sure it was readable by all.

```
[root@sandbox ~]# su - hdfs
[hdfs@sandbox ~]$ hdfs dfs -mkdir /otpc
[hdfs@sandbox ~]$ hdfs dfs -chmod 755 /otpc
```

#### Retrieve & Load Data

Then I pulled the zip file down and got it loaded into the `/otpc` folder on HDFS.

```
[hdfs@sandbox ~]$ wget https://www.dropbox.com/s/tpl4qmfq48ivwuh/faa-data.zip
[hdfs@sandbox ~]$ unzip faa-data.zip 
[hdfs@sandbox ~]$ mv faa-data faa
[hdfs@sandbox ~]$ hdfs dfs -put faa /otpc
[hdfs@sandbox ~]$ hdfs dfs -ls /otpc/faa
Found 5 items
-rw-r--r--   1 hdfs hdfs     205888 2017-01-22 19:27 /otpc/faa/airports.csv
-rw-r--r--   1 hdfs hdfs      37794 2017-01-22 19:27 /otpc/faa/carriers.csv
-rwar--r--   1 hdfs hdfs  136035258 2017-01-22 19:27 /otpc/faa/flights.csv
-rw-r--r--   1 hdfs hdfs     428796 2017-01-22 19:27 /otpc/faa/plane-data.csv
[hdfs@sandbox ~]$ exit
logout
[root@sandbox ~]# 
```

## The Comparison!!

* File Formats
  * [Delimeted Values](./file-formats/delimited/README.md)
  * [XML](./file-formats/xml/README.md)
  * [JSON](./file-formats/json/README.md)
  * Avro
  * Parquet
  * ORC

