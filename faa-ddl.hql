-- DDL for FAA raw datasets
--   ALL fields declared as string
--   Using column names aligned with provided header rows


DROP TABLE IF EXISTS carrier_raw;

CREATE EXTERNAL TABLE carrier_raw(
        code string, description string)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/otpc/faa/carrier'
    tblproperties ("skip.header.line.count"="1");


DROP TABLE IF EXISTS airport_raw;

CREATE EXTERNAL TABLE airport_raw(
        airport_code string, airport string, city string,
        state string, country string, latitude string, longitude string)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/otpc/faa/airport'
    tblproperties ("skip.header.line.count"="1");


DROP TABLE IF EXISTS plane_raw;

CREATE EXTERNAL TABLE plane_raw(
        tailnum string, type string, manufacturer string,
        issue_date string, model string, status string,
        aircraft_type string, engine_type string, year string)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/otpc/faa/plane'
    tblproperties ("skip.header.line.count"="1");


DROP TABLE IF EXISTS flight_raw;

CREATE EXTERNAL TABLE flight_raw(
        month string, day_of_month string, day_of_week string,
        dep_time string, arr_time string, unique_carrier string,
        flight_num string, tail_num string, 
        elapsed_time string, air_time string,
        arr_delay string, dep_delay string,
        origin string, dest string, distance string,
        taxi_in string, taxi_out string,
        cancelled string, cancellation_code string,
        diverted string)
      PARTITIONED BY (year string)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY ','
    STORED AS TEXTFILE
    LOCATION '/otpc/faa/flight';

-- and since we are going to load the data via the "back door" we need
--    to nudge the metastore to know about the directory being created
ALTER TABLE flight_raw ADD PARTITION(year='2008');
