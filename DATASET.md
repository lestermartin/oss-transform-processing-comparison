# OTPC: Data Set

This page describes the setup required for the dataset used in the comparison code of [this project](README.md).


## FAA Data

Many of the examples leverage a select dataset based on the [FAA's Aviation Data & Statistics](https://www.faa.gov/data_research/aviation_data_statistics/) offering.  Specifically, I'm focusing on the 2008 data than can be found at [faa-data.zip](https://www.dropbox.com/s/tpl4qmfq48ivwuh/faa-data.zip?dl=0) (~40MB).

You'll need to get those data files into HDFS in some way.  For me, I did the following activities on the Sandbox.

### Prepare a Shared Folder

I switched to the `hdfs` super-user and created a base folder to hold everything and made sure it was readable by all.

```
[root@sandbox ~]# su - hdfs
[hdfs@sandbox ~]$ hdfs dfs -mkdir /otpc
[hdfs@sandbox ~]$ hdfs dfs -chmod 755 /otpc
```

### Ingest Data into HDFS

Then I pulled the zip file down and got it loaded into the `/otpc` folder on HDFS.

```
[hdfs@sandbox ~]$ hdfs dfs -mkdir /otpc/faa
[hdfs@sandbox ~]$ wget https://www.dropbox.com/s/tpl4qmfq48ivwuh/faa-data.zip
[hdfs@sandbox ~]$ unzip faa-data.zip 
[hdfs@sandbox ~]$ hdfs dfs -mkdir /otpc/faa/airport
[hdfs@sandbox ~]$ hdfs dfs -put faa-data/airports.csv /otpc/faa/airport/2008.csv
[hdfs@sandbox ~]$ hdfs dfs -mkdir /otpc/faa/carrier
[hdfs@sandbox ~]$ hdfs dfs -put faa-data/carriers.csv /otpc/faa/carrier/2008.csv
[hdfs@sandbox ~]$ hdfs dfs -mkdir /otpc/faa/plane
[hdfs@sandbox ~]$ hdfs dfs -put faa-data/plane-data.csv /otpc/faa/plane/2008.csv
[hdfs@sandbox ~]$ hdfs dfs -mkdir -p /otpc/faa/flight/year=2008
[hdfs@sandbox ~]$ hdfs dfs -put faa-data/flights.csv /otpc/faa/flight/year=2008/2008.csv
[hdfs@sandbox ~]$ hdfs dfs -ls -R /otpc/faa
drwxr-xr-x   - hdfs hdfs          0 2017-02-12 05:53 /otpc/faa/airport
-rw-r--r--   1 hdfs hdfs     205888 2017-02-12 05:46 /otpc/faa/airport/2008.csv
drwxr-xr-x   - hdfs hdfs          0 2017-02-12 05:53 /otpc/faa/carrier
-rw-r--r--   1 hdfs hdfs      37794 2017-02-12 05:46 /otpc/faa/carrier/2008.csv
drwxr-xr-x   - hdfs hdfs          0 2017-02-12 18:05 /otpc/faa/flight
drwxr-xr-x   - hdfs hdfs          0 2017-02-12 18:05 /otpc/faa/flight/year=2008
-rw-r--r--   1 hdfs hdfs  136035258 2017-02-12 05:48 /otpc/faa/flight/year=2008/2008.csv
drwxr-xr-x   - hdfs hdfs          0 2017-02-12 05:49 /otpc/faa/plane
-rw-r--r--   1 hdfs hdfs     428796 2017-02-12 05:49 /otpc/faa/plane/2008.csv
[hdfs@sandbox ~]$ exit
logout
[root@sandbox ~]# 
```

### Create External Tables

Map these "raw" files with `ENTITY_raw` EXTERNAL Hive tables so that in addition to Hive being able to use them, Pig can leverage them via `HCatalog` and Spark can via the `HiveContext`.

Execute [`faa-ddl.hql`](faa-ddl.hql) to create these tables.

### Create Managed Tables

Execute [`orc-ddl.hql`](orc-ddl.hql) to build optimized Hive managed tables with appropriate datatypes.
