# OTPC: Data Quality and Profiling

This page compares using Pig, Hive and Spark in the data quality and profiling domain which focus on determining accuracy and completeness, as well as correcting/enhancing, input data.

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

Simulate and address validation/standardization function by concatenating a lowercase version of the `state` with an uppercase version of `city`.




### WHAT'S NEXT??





## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../README.md#script-execution) main page for options on running these scripts.

### Pig

#### Numeric Validation

[`numeric-validation.pig`](numeric-validation.pig) shows a series of steps that you can attack in a methodical pipelining style to finalized a dataset with just the validated records.  See the Hive description of this use case to understand why `(tot_not_null,3355)` is the correct number of records to end up with.


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

UP NEXT!!!





### Spark

Spark can method chain a series of DataFrame transformations to quickly get to the validated records.  Execute [`numeric-validation.spark`](numeric-validation.spark) to see the following output which shows the correct number of final records; 3355.

```
root
 |-- airport_code: string (nullable = true)
 |-- latitude: float (nullable = true)
 |-- longitude: float (nullable = true)
res40: Long = 3355
```


## Results

IN PROGRESS...