# OTPC: Data Profiling

This page compares using Pig, Hive and Spark in regards to data profling which is a technique used to examine data for different purposes like determining accuracy and completeness. This technique improves [Data Quality](../data-quality/README.md).

## Setup

Ensure the operations described in [loading the data set](../DATASET.md) are completed.

## Use Case

Data profiling is the method of examining the data available in a data source and collecting statistics and information about that data. Such statistics help to identify the use and data quality of metadata. This method is widely used in enterprise data warehousing.

Data profiling clarifies the structure, relationship, content and derivation rules of data, which aid in the understanding of anomalies within metadata. Data profiling uses different kinds of descriptive statistics including mean, minimum, maximum, percentile, frequency and other aggregates such as count and sum. The additional metadata information obtained during profiling is data type, length, discrete values, uniqueness and abstract type recognition.
Perform the following simple examples of classical data quality functions.

For this comparison, each of the processing frameworks should be explored for what is inherently available in this space.  Generally speaking, we are looking for what kind of data statistics can be quickly generated.  All frameworks would allow us to build a comprehensive (and domain appropriate) data profiling framework given time, but this is not being considered here.

## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../README.md#script-execution) main page for options on running these scripts.

### Pig

Core Pig does not offer a statistical analysis set of services.  The [DataFu](http://datafu.apache.org/) project has a [Statistics](http://datafu.incubator.apache.org/docs/datafu/guide/statistics.html) package than can be leveraged to provide statistics such as shown in the following example.

```
Column Name: sales_price
Row Count: 163794
Null Count: 0
Distinct Count: 1446
Highest Value: 70589
Lowest Value: 1
Total Value: 21781793
Mean Value: 132.98285040966093
Variance: 183789.18332067598
Standard Deviation: 428.7064069041609
```

> The above example is from Chapter 3 of [Pig Design Patterns](https://www.packtpub.com/big-data-and-business-intelligence/pig-design-patterns).

### Hive

Hive has the ability to calculate column level statistics that can be stored in the Metastore.  This is simple to invoke.

```
0: jdbc:hive2://127.0.0.1:10000> ANALYZE TABLE flight COMPUTE STATISTICS FOR COLUMNS;
```

Upon completion, you can request the calculated values by column.

```
0: jdbc:hive2://127.0.0.1:10000> DESCRIBE FORMATTED flight air_time;
+-------------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+--+
|        col_name         |       data_type       |          min          |          max          |       num_nulls       |    distinct_count     |      avg_col_len      |      max_col_len      |       num_trues       |      num_falses       |        comment        |
+-------------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+--+
| # col_name              | data_type             | min                   | max                   | num_nulls             | distinct_count        | avg_col_len           | max_col_len           | num_trues             | num_falses            | comment               |
|                         | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  |
| air_time                | int                   | 0                     | 757                   | 0                     | 316                   |                       |                       |                       |                       | from deserializer     |
+-------------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+--+
3 rows selected (0.136 seconds)
```

Some of the values above don't really make sense (avg/max column length) for numeric types which implies that statistics can also been presented for string columns as shown below.

```
0: jdbc:hive2://127.0.0.1:10000> ANALYZE TABLE airport COMPUTE STATISTICS FOR COLUMNS;
0: jdbc:hive2://127.0.0.1:10000> DESCRIBE FORMATTED airport city;
+-------------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+--+
|        col_name         |       data_type       |          min          |          max          |       num_nulls       |    distinct_count     |      avg_col_len      |      max_col_len      |       num_trues       |      num_falses       |        comment        |
+-------------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+--+
| # col_name              | data_type             | min                   | max                   | num_nulls             | distinct_count        | avg_col_len           | max_col_len           | num_trues             | num_falses            | comment               |
|                         | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  | NULL                  |
| city                    | string                |                       |                       | 0                     | 2535                  | 8.407                 | 32                    |                       |                       | from deserializer     |
+-------------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+-----------------------+--+
3 rows selected (0.208 seconds)
```


### Spark

As shown in the example within [`describe.spark`](describe.spark), the `DataFrame` class has a `describe()` method that "Computes statistics for numeric columns, including count, mean, stddev, min, and max. If no columns are given, this function computes statistics for all numerical columns."

Here is the output when requested only on a few columns.

```
+-------+-----------------+-----------------+------------------+
|summary|         distance|         air_time|         arr_delay|
+-------+-----------------+-----------------+------------------+
|  count|          2056494|          2056494|           2056494|
|   mean|728.3896009421861|103.9721783773743| 8.174559711820214|
| stddev|563.2249684859466|67.42112792270458|38.513181707062174|
|    min|               11|                0|               -91|
|    max|             4962|              757|              2461|
+-------+-----------------+-----------------+------------------+
```

## Results

If you do a little bit of coding around the DataFu library, Pig has a solid chance of satisfying of of your baseline statistics functions, but the inherent abilities of Hive and Spark make them much easier to use.

As Hive and Spark end up presenting different statistics and on a different set of datatypes, you really need to couple their combined output to satisfy the base statistics we were trying to attain in this categy.