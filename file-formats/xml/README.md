# OTPC: File-Formats: XML

This page compares reading XML input with Pig, Hive and Spark.  


## Setup

Move the [`catalog.xml`](catalog.xml) file into HDFS after creating an `/otpc/ff/xml` directory.

## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../../README.md#script-execution) main page for options on running these scripts.

### Pig

Execute [`read-xml.pig`](read-xml.pig) to read in this data and cast appropriately before describing and dumping the dataset as shown in the following output.

```
formatted: {title: chararray,book: chararray,price: float,year: int}
(Programming Pig,Alan Gates,23.17,2016)
(Apache Hive Essentials,Dayong Du,39.99,2015)
(Spark in Action,Petar Zecevic,41.24,2016)
```

### Hive

Unfortunately, Hive cannot deal with an XML file formatted in a "normal" / humanly-readable way that has a tag on each line.  Two popular approaches are to flatten the doc onto a single line or, as I'm doing in my example, to strip the outer tag (`<catalog>` in this case) and have each instance of the next level tag be on a separate line.

See [`flat-catalog.xml`](flat-catalog.xml) that has been pre-processed to appear this way.  This file needs to be moved into the newly created `/otpc/ff/xml/flat` HDFS folder.

Execute [`load-xml.hql`](load-xml.hql) to create an external table to map to the flattened XML file and then use the [XPathUDF](https://cwiki.apache.org/confluence/x/A4OhAQ) to convert the data into a tabular format that can be used to create another, more optimized, table as shown in the following output.

```
0: jdbc:hive2://localhost:10000> desc book_catalog;
+-----------+------------+----------+--+
| col_name  | data_type  | comment  |
+-----------+------------+----------+--+
| title     | string     |          |
| author    | string     |          |
| price     | float      |          |
| year      | int        |          |
+-----------+------------+----------+--+
4 rows selected (0.164 seconds)
0: jdbc:hive2://localhost:10000> select * from book_catalog;
+-------------------------+----------------------+---------------------+--------------------+--+
|   book_catalog.title    | book_catalog.author  | book_catalog.price  | book_catalog.year  |
+-------------------------+----------------------+---------------------+--------------------+--+
| Programming Pig         | Alan Gates           | 23.17               | 2016               |
| Apache Hive Essentials  | Dayong Du            | 39.99               | 2015               |
| Spark in Action         | Petar Zecevic        | 41.24               | 2016               |
+-------------------------+----------------------+---------------------+--------------------+--+
3 rows selected (0.15 seconds)
```


### Spark

For the 1.x versions of Spark you can use [branch-0.3 of databrix/spark-xml](https://github.com/databricks/spark-xml/tree/branch-0.3) to make this SUPER SIMPLE.  

Although instructions such as http://stackoverflow.com/questions/36897910/how-to-run-spark-on-zeppelin-to-analyze-xml-files show you it is easy to pull the extra dependency into Zeppelin, I'm just kicking of the Spark shell with this extra parameter to pull the needed classes in.

```
spark-shell --packages com.databricks:spark-xml_2.10:0.4.1
```

Execute the SINGLE STATEMENT in [`read-xml.spark`](read-xml.spark) to transform the (non-flattened) XML file into a DataFrame as shown in the following output.

```
scala> df.printSchema()
root
 |-- AUTHOR: string (nullable = true)
 |-- PRICE: double (nullable = true)
 |-- TITLE: string (nullable = true)
 |-- YEAR: long (nullable = true)
scala> df.show()
+-------------+-----+--------------------+----+
|       AUTHOR|PRICE|               TITLE|YEAR|
+-------------+-----+--------------------+----+
|   Alan Gates|23.17|     Programming Pig|2016|
|    Dayong Du|39.99|Apache Hive Essen...|2015|
|Petar Zecevic|41.24|     Spark in Action|2016|
+-------------+-----+--------------------+----+
```

## Results

Clearly, Spark is dramatically simpler than either of the other models.  Pig and Hive are tied for a distance second taking the explicit XPath route instead of automagically inferring the schema. 

