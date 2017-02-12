# OTPC: File-Formats: Delimited Values

This page compares reading delimited values files with Pig, Hive and Spark.  


## Setup

Move the [`catalog.del`](catalog.del) file into HDFS after creating an `/otpc/ff/del/data` directory.  This is a pipe-delimited data file.

## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../../README.md#script-execution) main page for options on running these scripts.

### Pig

Execute [`read-del.pig`](read-del.pig) to read in this data and and dumping the dataset as shown in the following output.

```
book_catalog: {title: chararray,author: chararray,price: float,year: int}
(Programming Pig,Alan Gates,23.17,2016)
(Apache Hive Essentials,Dayong Du,39.99,2015)
(Spark in Action,Petar Zecevic,41.24,2016)
```

### Hive

Execute [`load-del.hql`](load-del.hql) to create an external table to map to the pipe-delimited file as shown in the following output.

```
0: jdbc:hive2://localhost:10000> desc book_catalog_pipe;
+-----------+------------+----------+--+
| col_name  | data_type  | comment  |
+-----------+------------+----------+--+
| title     | string     |          |
| author    | string     |          |
| price     | float      |          |
| year      | int        |          |
+-----------+------------+----------+--+
4 rows selected (0.15 seconds)
0: jdbc:hive2://localhost:10000> select * from book_catalog_pipe;
+--------------------------+---------------------------+--------------------------+-------------------------+--+
| book_catalog_pipe.title  | book_catalog_pipe.author  | book_catalog_pipe.price  | book_catalog_pipe.year  |
+--------------------------+---------------------------+--------------------------+-------------------------+--+
| Programming Pig          | Alan Gates                | 23.17                    | 2016                    |
| Apache Hive Essentials   | Dayong Du                 | 39.99                    | 2015                    |
| Spark in Action          | Petar Zecevic             | 41.24                    | 2016                    |
+--------------------------+---------------------------+--------------------------+-------------------------+--+
3 rows selected (0.136 seconds)
```

### Spark

Execute [`read-del.spark`](read-del.spark) to read the file as an RDD and then apply schema to it before converting it to a DataFrame as shown in the following output.

```
root
 |-- title: string (nullable = true)
 |-- author: string (nullable = true)
 |-- price: float (nullable = false)
 |-- year: integer (nullable = false)
+--------------------+-------------+-----+----+
|               title|       author|price|year|
+--------------------+-------------+-----+----+
|     Programming Pig|   Alan Gates|23.17|2016|
|Apache Hive Essen...|    Dayong Du|39.99|2015|
|     Spark in Action|Petar Zecevic|41.24|2016|
+--------------------+-------------+-----+----+
```

## Results

Both Pig and Hive are in there elements here.  Spark has to take a roundabout way via the RDD API to eventually become a DataFrame which is not exhaustive, but is clearly a bit more intensive than the other frameworks.