# OTPC: Source to Target Mapping

This page compares using Pig, Hive and Spark for the classic ETL need to map one dataset to another.  This includes these basic scenarios.

| Column Presence | Action |
| --------------- | ------ |
| Source and Target | Straight pump of data from source column to target column (could be renamed, cleaned, transformed, etc) |
| Source, not in Target | Ignore this column |
| Target, not in Source | Implies a hard-coded or calculated value will be inserted or updated |

## Setup

Ensure the operations described in [loading the data set](DATASET.md) are completed.

## Use Case

The `airport_raw` table has the following format.

```
+---------------+------------+----------+--+
|   col_name    | data_type  | comment  |
+---------------+------------+----------+--+
| airport_code  | string     |          |
| airport       | string     |          |
| city          | string     |          |
| state         | string     |          |
| country       | string     |          |
| lat           | string     |          |
| long          | string     |          |
+---------------+------------+----------+--+
```

Create a new dataset with the following requirements _(more complicated scenarios such as data ranges, lookups, type conversion, **eliminating header rows**, etc are described in ()XXX DON'T FORGET TO ADD LINK TO Data Quality MARKDOWN FILE XXX)_

* Change column names
  * `airport_code` to `airport_cd`
  * `airport` to `name`
* Carry columns over as named
  * `city`
  * `state`
  * `country`
* Exclude the following columns
  * `lat`
  * `long`
* Hard-code a new `governing_agency` column with the value `FAA`

## Script Execution

See the **Script Execution** section of the [oss-transform-processing-comparison](../../README.md#script-execution) main page for options on running these scripts.

### Pig

We simply need to perform a projection using the [`FOREACH ... GENERATE`](http://pig.apache.org/docs/r0.16.0/basic.html#foreach) operation as shown in [`source2target.pig`](source2target.pig) script which generates the following output.

```
target_airport: {airport_cd: chararray,name: chararray,city: chararray,state: chararray,country: chararray,governing_agency: chararray}
(00M,Thigpen,BaySprings,MS,USA,FAA)
(00R,LivingstonMunicipal,Livingston,TX,USA,FAA)
(00V,MeadowLake,ColoradoSprings,CO,USA,FAA)
(01G,Perry-Warsaw,Perry,NY,USA,FAA)
(01J,HilliardAirpark,Hilliard,FL,USA,FAA)
```

### Hive

This is easily done with Hive via a simple `SELECT` statement as shown by executing [`source2target.hql`](source2target.hql) as shown in the following output.

```
0: jdbc:hive2://localhost:10000> DESC target_airport;
+-------------------+------------+----------+--+
|     col_name      | data_type  | comment  |
+-------------------+------------+----------+--+
| airport_cd        | string     |          |
| name              | string     |          |
| city              | string     |          |
| state             | string     |          |
| country           | string     |          |
| governing_agency  | string     |          |
+-------------------+------------+----------+--+
6 rows selected (0.146 seconds)
0: jdbc:hive2://localhost:10000> SELECT * FROM target_airport LIMIT 5;
+----------------------------+----------------------+----------------------+-----------------------+-------------------------+----------------------------------+--+
| target_airport.airport_cd  | target_airport.name  | target_airport.city  | target_airport.state  | target_airport.country  | target_airport.governing_agency  |
+----------------------------+----------------------+----------------------+-----------------------+-------------------------+----------------------------------+--+
| 00M                        | Thigpen              | BaySprings           | MS                    | USA                     | FAA                              |
| 00R                        | LivingstonMunicipal  | Livingston           | TX                    | USA                     | FAA                              |
| 00V                        | MeadowLake           | ColoradoSprings      | CO                    | USA                     | FAA                              |
| 01G                        | Perry-Warsaw         | Perry                | NY                    | USA                     | FAA                              |
| 01J                        | HilliardAirpark      | Hilliard             | FL                    | USA                     | FAA                              |
+----------------------------+----------------------+----------------------+-----------------------+-------------------------+----------------------------------+--+
5 rows selected (0.126 seconds)
```

### Spark

Spark can method chain a series of DataFrame transformations to attain this source to target mapping.  Execute [`source2target.spark`](source2target.spark) to see the following output.

```
root
 |-- airport_cd: string (nullable = true)
 |-- name: string (nullable = true)
 |-- city: string (nullable = true)
 |-- state: string (nullable = true)
 |-- country: string (nullable = true)
 |-- governing_agency: string (nullable = false)
+----------+-------------------+---------------+-----+-------+----------------+
|airport_cd|               name|           city|state|country|governing_agency|
+----------+-------------------+---------------+-----+-------+----------------+
|      iata|            airport|           city|state|country|             FAA|
|       00M|            Thigpen|     BaySprings|   MS|    USA|             FAA|
|       00R|LivingstonMunicipal|     Livingston|   TX|    USA|             FAA|
|       00V|         MeadowLake|ColoradoSprings|   CO|    USA|             FAA|
|       01G|       Perry-Warsaw|          Perry|   NY|    USA|             FAA|
|       01J|    HilliardAirpark|       Hilliard|   FL|    USA|             FAA|
+----------+-------------------+---------------+-----+-------+----------------+
```

## Results

No clear winner here as they all can address this requirement in a straightforward manner.