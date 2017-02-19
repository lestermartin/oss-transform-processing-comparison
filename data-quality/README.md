# OTPC: Data Quality

This page compares using Pig, Hive and Spark in the data quality domain which focuses on detecting/correcting/enhancing input data.

## Setup

Ensure the operations described in [loading the data set](../DATASET.md) are completed.

## Use Case

Perform the following simple examples of classical data quality functions.

### Numeric Validation

Cast raw data to to correct numeric type and apply checks to see if converted values are within a given range.  For this example, convert the `airport_raw`'s `latitude` and `longitude` `string` values to `float` and ensure they are within normal ranges.  

> The valid range of latitude in degrees is -90 and +90 for the southern and northern hemisphere respectively. Longitude is in the range -180 and +180 specifying coordinates west and east of the Prime Meridian, respectively.

For simplicity's sake, let's just assume that if the `latitude` value is > 70 or the `longitude` is < -170 then we have an invalid set of coordinates.

**NOTE:** In practice, it is unlikely these records would truly be eliminated for having invalid coordinates.  More likely, they would be NULL'd out and possibly reported on for additional investigation.

### String Validation

A standard string validation routine is to eliminate any extra spaces that may be present and then conform the string to a max length.  For this example, trim any leading and trailing spaces from the `city` value from the `airport_raw` dataset.  Then identify any records that are longer than 30 characters _(this is just a figurative example and in reality we would look to allow something much larger such as 100 or 150 characters)_ before simply truncating at that point and limiting the string to that size in the transformed dataset.

### Additional Validations

There are many additional concepts addressed in modern ETL applications in this data quality family that can be explored (later) which include.

* Date format validation and conversion
* Currency validation
* Additional string validations such as pattern matching for things like SSNs and phone numbers
* Data enrichment


## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../README.md#script-execution) main page for options on running these scripts.

### Pig

#### Numeric Validation

[`numeric-validation.pig`](numeric-validation.pig) shows a series of steps that you can attack in a methodical pipelining style to finalized a dataset with just the validated records.  See the Hive description of this use case to understand why `(tot_not_null,3355)` is the correct number of records to end up with.

#### String Validation

[`string-validation.pig`](string-validation.pig) shows how to isolate the records whose field is too long and then does simple nesting of functions to trim any unwanted spaces and then grabbing only the first 30 characters for the finalized version of the dataset.  The following output shows the single record that was too big as well as the schema of the finalized dataset.

```
(PWK,Palwaukee,Chicago/Wheeling/ProspectHeights,IL,USA,42.11418083,-87.90148083)
source_airport_validated: {airport_code: chararray,airport: chararray,city: chararray,state: chararray,country: chararray}
```


### Hive

#### Numeric Validation

Regarding numeric (and date) validation, an accepted approach centers around loading data in a raw/staging table without performing any validation on this first set of tables.  In this scenario, all columns are defined as `string` so that you will not get any NULL values when doing a select.  The [Setup](#setup) section of this page produces "raw" tables like this.

From this starting point, we can see how many records we have in the original file.

```
0: jdbc:hive2://localhost:10000> SELECT COUNT(*) AS tot_raw FROM airport_raw;
+----------+--+
| tot_raw  |
+----------+--+
| 3376     |
+----------+--+
1 row selected (8.465 seconds)
```

You would then create a second set of tables that attempts standard casting operations for things like numeric data types and placing them in the most appropriate data types.  In this scenario, fields that do not pass through this level of data quality will be marked as NULL.  This can be visualized by running [`numeric-casting.hql`](numeric-casting.hql) and see the results below that identify how many records failed to convert correctly.

```
0: jdbc:hive2://localhost:10000> SELECT airport_code FROM partial_airport_converted WHERE latitude IS NULL OR longitude IS NULL;
+---------------+--+
| airport_code  |
+---------------+--+
| 35A           |
| 53A           |
| BTR           |
| HTW           |
| N25           |
| PUW           |
| RDG           |
| RVS           |
| TOC           |
+---------------+--+
9 rows selected (0.154 seconds)
```

Then another table could be build of records that pass additional validation.  The following shows there are 12 records that should fail this test.

```
0: jdbc:hive2://localhost:10000> select latitude, longitude from partial_airport_converted where latitude > 70 or longitude < -170 limit 20;
+------------+-------------+--+
|  latitude  |  longitude  |
+------------+-------------+--+
| 51.877964  | -176.64603  |
| 52.22035   | -174.20634  |
| 70.20995   | -151.00555  |
| 70.46728   | -157.43573  |
| 70.638     | -159.99475  |
| 71.285446  | -156.766    |
| 70.1339    | -143.57704  |
| 63.766766  | -171.73282  |
| 14.331023  | -170.71053  |
| 70.194756  | -148.46516  |
| 57.16733   | -170.22044  |
| 63.686394  | -170.49263  |
+------------+-------------+--+
12 rows selected (0.161 seconds)
```

Check out [`numeric-range.hql`](numeric-range.hql) for an illustrative example of creating a "final" table to hold only the fully vetted data as well as the query results of the total number of these records that made it through the full numeric validation described earlier _(3376 original records - 9 that failed conversion and - 12 invalid ranges = 3355)_.

```
0: jdbc:hive2://localhost:10000> select COUNT(*) AS tot_validated FROM partial_airport_validated;
+----------------+--+
| tot_validated  |
+----------------+--+
| 3355           |
+----------------+--+
1 row selected (0.093 seconds)
```

#### String Validation

The following query shows us that there is only a single record that is longer than 30 characters in length.

```
0: jdbc:hive2://127.0.0.1:10000> SELECT COUNT(*) FROM airport_raw WHERE LENGTH(city) > 30;
+------+--+
| _c0  |
+------+--+
| 1    |
+------+--+
1 row selected (5.249 seconds)
```

The problem is easily solved with a simple query as shown in [`string-validation.hql`](string-validation.hql) which grabs the first 30 characters after trimming leading/trailing spaces.  The result is that the "final" table only holds the properly validated/converted records.

```
0: jdbc:hive2://127.0.0.1:10000> SELECT COUNT(*) FROM partial_airport_validated WHERE LENGTH(city) > 30;
+------+--+
| _c0  |
+------+--+
| 0    |
+------+--+
1 row selected (5.346 seconds)
```

This approach did not store a "converted" table like done with the numeric validation, but for reporting purposes, a simple query such as presented in [`string-outliers.hql`](string-outliers.hql) could be run to store the results (below) for further investigation.  Generally speaking, these kinds of string length violations do not prevent records from being loaded, but again, could be reported on.

```
0: jdbc:hive2://127.0.0.1:10000> SELECT airport_code, city FROM airport_raw WHERE LENGTH(TRIM(city)) > 30;
+---------------+-----------------------------------+--+
| airport_code  |               city                |
+---------------+-----------------------------------+--+
| PWK           | Chicago/Wheeling/ProspectHeights  |
+---------------+-----------------------------------+--+
1 row selected (0.14 seconds)
```

### Spark

#### Numeric Validation

Spark can method chain a series of DataFrame transformations to quickly get to the validated records.  Execute [`numeric-validation.spark`](numeric-validation.spark) to see the following output which shows the correct number of final records; 3355.

```
root
 |-- airport_code: string (nullable = true)
 |-- latitude: float (nullable = true)
 |-- longitude: float (nullable = true)
res40: Long = 3355
```

#### String Validation

As shown in [`string-validation.spark`](string-validation.spark), this is solved in a single line of code with chained transformations to trim possible unwanted spaces and then conform the newly created attribute to only be the desired length.  The following is the output from this script and shows there was a single record initially and then no records with this problem.

```
before_too_long_cities: org.apache.spark.sql.DataFrame = [airport_code: string, airport: string, city: string, state: string, country: string, latitude: string, longitude: string]res30: Long = 1
airport_validated: org.apache.spark.sql.DataFrame = [airport_code: string, airport: string, state: string, country: string, latitude: string, longitude: string, city: string]
res30: Long = 1
airport_validated: org.apache.spark.sql.DataFrame = [airport_code: string, airport: string, state: string, country: string, latitude: string, longitude: string, city: string]
root
 |-- airport_code: string (nullable = true)
 |-- airport: string (nullable = true)
 |-- state: string (nullable = true)
 |-- country: string (nullable = true)
 |-- latitude: string (nullable = true)
 |-- longitude: string (nullable = true)
 |-- city: string (nullable = true)
after_too_long_cities: org.apache.spark.sql.DataFrame = [airport_code: string, airport: string, state: string, country: string, latitude: string, longitude: string, city: string]
res32: Long = 0
```


## Results

All three frameworks identify the data problems and rectify them in a pretty consistent way just as you would expect to address them in just about any programming environment.  At least in my opinion, Hive really is not the tool for a series of data testing and conforming logic due to its need to continually build tables for the output of each step along the way.

Pig and Spark tackle this more appropriately (again, at least in my opinion).  Both off crisp and elegant solutions with the differnce really being a matter of style.