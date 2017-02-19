# OTPC: Core Processing

This page presents quick comparisions across Pig, Hive and Spark with respect to the core processing features one would expect in a programming framework being used for data transformation, cleansing and enrichment.

## Setup

Ensure the operations described in [loading the data set](../DATASET.md) are completed.

## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../README.md#script-execution) main page for options on running these scripts.

## Functionality By Example

### Filtering

Create a list of the `airport` records that are in the state of Texas.

#### Pig

Simple activity for Pig as shown in [`filtering.pig`](filtering.pig).

#### Hive

[`filtering.hql`] shows it just doesn't get any simplier that this.

#### Spark


### Sorting

Order the `flight` dataset by the longest departure delays first and for ties on this bad value, secondary sort on the carrier names and their flight numbers.

#### Pig

The Pig Latin for this is rather straightforward as seen in [`sorting.pig`](sorting.pig).

#### Hive

Easy to do in SQL as visualized in [`sorting.hql`](sorting.hql).


#### Spark


### Joining

Augment the `flight` dataset to include the year the plane was manufactured.

#### Pig

This gets a bit "chatty" in Pig Latin as visualized in [`joining.pig`](joining.pig).

#### Hive

This can easily be done with SQL as seen in [`joining.hql`](joining.hql).


#### Spark

### Distinct Values

Determine a distinct list of `aircraft_type` values from the `plane` dataset.  That list will include one call "Rotorcraft" which should be used to determine a distinct list of the `manufacturer`s for this type of aircraft.

#### Pig

Run [`distinct.pig`](distinct.pig) to generate the following two lists.

Distinct aircraft types.

```
(Balloon)
(Rotorcraft)
(Fixed Wing Multi-Engine)
(Fixed Wing Single-Engine)
()
```

Distinct manufacturers of rotorcraft.

```
(BELL)
(SIKORSKY)
(AGUSTA SPA)
(AEROSPATIALE)
(COBB INTL/DBA ROTORWAY INTL IN)
```

#### Hive

Submit the two queries in [`distinct.hql`](distinct.hql) to get the following results.

Distinct aircraft types.

```
+---------------------------+--+
|       aircraft_type       |
+---------------------------+--+
| NULL                      |
| Balloon                   |
| Fixed Wing Multi-Engine   |
| Fixed Wing Single-Engine  |
| Rotorcraft                |
+---------------------------+--+
```

Distinct manufacturers of rotorcraft.

```
+---------------------------------+--+
|          manufacturer           |
+---------------------------------+--+
| AEROSPATIALE                    |
| AGUSTA SPA                      |
| BELL                            |
| COBB INTL/DBA ROTORWAY INTL IN  |
| SIKORSKY                        |
+---------------------------------+--+
```

#### Spark

### Aggregation

Determine the average `dep_delay` and average `taxi_out` values by aggregating the `origin` airport for all `flight` records.

#### Pig

Execute [`aggregate.pig`](aggregate.pig) to generate the following results.

```
(PIR,49.5,14.0)
(ACY,35.916666666666664,11.833333333333334)
(ACK,25.558333333333334,20.625)
(CEC,23.40764331210191,12.773885350318471)
(LMT,23.40268456375839,11.208053691275168)
```

#### Hive

Run the query at [`aggregate.hql`](aggregate.hql) to generate the following results.

```
+---------+---------------------+---------------------+--+
| origin  |    avg_dep_delay    |    avg_taxi_out     |
+---------+---------------------+---------------------+--+
| PIR     | 49.5                | 14.0                |
| ACY     | 35.916666666666664  | 11.833333333333334  |
| ACK     | 25.558333333333334  | 20.625              |
| CEC     | 23.40764331210191   | 12.773885350318471  |
| LMT     | 23.40268456375839   | 11.208053691275168  |
+---------+---------------------+---------------------+--+
5 rows selected (10.74 seconds)
```

#### Spark










## Results

If you do a little bit of coding around the DataFu library, Pig has a solid chance of satisfying all of your baseline statistics functions, but the inherent abilities of Hive and Spark make them much easier to use.

As Hive and Spark end up presenting different statistics and on a different set of datatypes, you really need to couple their combined output to satisfy the base statistics we were trying to attain in this category.