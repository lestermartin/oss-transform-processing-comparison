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

Perform the operations described in [loading the data set](DATASET.md).

## The Comparison!!

* File Formats
  * [Delimeted Values](./file-formats/delimited/README.md)
  * [XML](./file-formats/xml/README.md)
  * [JSON](./file-formats/json/README.md)
  * To be explored (later)
    * Other "normal" big data formats such as Avro, Parquet, ORC
    * Esoteric formats such as EBCDIC and compact RYO solns
* [Source to Target Mapping](./mapping/README.md)
* [Data Quality](./data-quality/README.md)
