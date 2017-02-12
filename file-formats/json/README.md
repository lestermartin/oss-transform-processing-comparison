# OTPC: File-Formats: JSON

This page compares reading JSON input with Pig, Hive and Spark.  


## Setup

Move the [`catalog.json`](catalog.json) file into HDFS after creating an `/otpc/ff/json/data` directory.  This data file is expressed in a flattened structure as the Pig and Hive SerDe's seem to only work with that approach.

## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../../README.md#script-execution) main page for options on running these scripts.

### Pig

Execute [`read-json.pig`](read-json.pig) to read in this data and cast appropriately before describing and dumping the dataset as shown in the following output.

```
book_catalog: {title: chararray,author: chararray,price: float,year: int}
(Programming Pig,Alan Gates,23.17,2016)
(Apache Hive Essentials,Dayong Du,39.99,2015)
(Spring in Action,Petar Zecevic,41.24,2016)
```

### Hive

Execute [`load-json.hql`](load-json.hql) to create an external table to map to the flattened JSON file as shown in the following output.

**NOTE:** *The Ambari Hive View was throwing me some misleading error messages, but the table was getting created just fine.*

```
0: jdbc:hive2://localhost:10000> desc book_catalog_json;
+-----------+------------+--------------------+--+
| col_name  | data_type  |      comment       |
+-----------+------------+--------------------+--+
| title     | string     | from deserializer  |
| author    | string     | from deserializer  |
| price     | float      | from deserializer  |
| year      | int        | from deserializer  |
+-----------+------------+--------------------+--+
4 rows selected (0.198 seconds)
0: jdbc:hive2://localhost:10000> select * from book_catalog_json;
+--------------------------+---------------------------+--------------------------+-------------------------+--+
| book_catalog_json.title  | book_catalog_json.author  | book_catalog_json.price  | book_catalog_json.year  |
+--------------------------+---------------------------+--------------------------+-------------------------+--+
| Programming Pig          | Alan Gates                | 23.17                    | 2016                    |
| Apache Hive Essentials   | Dayong Du                 | 39.99                    | 2015                    |
| Spring in Action         | Petar Zecevic             | 41.24                    | 2016                    |
+--------------------------+---------------------------+--------------------------+-------------------------+--+
3 rows selected (0.116 seconds)
```

### Spark

Execute the SINGLE STATEMENT in [`read-json.spark`](read-json.spark) to transform the JSON file into a DataFrame as shown in the following output.

```
scala> df.printSchema()
root
 |-- author: string (nullable = true)
 |-- price: double (nullable = true)
 |-- title: string (nullable = true)
 |-- year: long (nullable = true)
scala> df.show()
+-------------+-----+--------------------+----+
|       author|price|               title|year|
+-------------+-----+--------------------+----+
|   Alan Gates|23.17|     Programming Pig|2016|
|    Dayong Du|39.99|Apache Hive Essen...|2015|
|Petar Zecevic|41.24|    Spring in Action|2016|
+-------------+-----+--------------------+----+
```

## Results

Spark is blazingly simple.  Pig and Hive are close followers as you just need to replicate a bit of the schema for each. 

