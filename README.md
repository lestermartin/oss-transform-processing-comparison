# oss-transform-processing-comparison

This project is intended to house the examples used in my upcoming DevNexus [Transformation Processing Smackdown; Spark vs Hive vs Pig](http://devnexus.com/s/devnexus2017/presentations/17533) presentation.

## Setup

The following information should help you get setup to run the examples.

### Hadoop Cluster

First, you will need a Hadoop cluster with Pig, Hive and Spark properly installed.  You have MANY options (and a couple of vendors in addition to RYO from http://hadoop.apache.org/).  

For myself, and since I work for Hortonworks right now, I'm going to leverage the [Hortonworks Sandbox](http://hortonworks.com/products/sandbox/), but again, you can use whatever Hadoop cluster you want.

### Data Set

Many of the examples leverage a select dataset based on the [FAA's Aviation Data & Statistics](https://www.faa.gov/data_research/aviation_data_statistics/) offering.  Specifically, I'm focusing on the 2008 data than can be found at [faa-data.zip](https://www.dropbox.com/s/tpl4qmfq48ivwuh/faa-data.zip?dl=0) (~40MB).

You'll need to get those data files into HDFS in some way.  For me, I did the following activities on the Sandbox.

#### Prepare a Shared Folder

I switched to the `hdfs` super-user and created a base folder to hold everything and made sure it was readable by all.

```
[root@sandbox ~]# su - hdfs
[hdfs@sandbox ~]$ hdfs dfs -mkdir /faa
[hdfs@sandbox ~]$ hdfs dfs -chmod 755 /faa
```

#### Retrieve & Load Data

Then I pulled the zip file down and got it loaded into the `/faa` folder on HDFS.

```
[hdfs@sandbox ~]$ wget https://www.dropbox.com/s/tpl4qmfq48ivwuh/faa-data.zip
[hdfs@sandbox ~]$ unzip faa-data.zip 
[hdfs@sandbox ~]$ mv faa-data data
[hdfs@sandbox ~]$ hdfs dfs -put data /faa
[hdfs@sandbox ~]$ hdfs dfs -ls /faa/data
Found 5 items
-rw-r--r--   1 hdfs hdfs     205888 2017-01-22 19:27 /faa/data/airports.csv
-rw-r--r--   1 hdfs hdfs      37794 2017-01-22 19:27 /faa/data/carriers.csv
-rw-r--r--   1 hdfs hdfs  136035258 2017-01-22 19:27 /faa/data/flights.csv
-rw-r--r--   1 hdfs hdfs     428796 2017-01-22 19:27 /faa/data/plane-data.csv
[hdfs@sandbox ~]$ exit
logout
[root@sandbox ~]# 
```

