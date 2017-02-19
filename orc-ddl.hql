-- Using PARQUET instead of ORC because of
--    https://issues.apache.org/jira/browse/SPARK-15705

DROP TABLE IF EXISTS carrier;

CREATE TABLE carrier STORED AS PARQUET AS
	SELECT code AS carrier_cd,
           description AS dscrptn
      FROM carrier_raw;

DROP TABLE IF EXISTS airport;

CREATE TABLE airport STORED AS PARQUET AS
	SELECT airport_code AS airport_cd,
           airport AS name,
           city, state, country,
           CAST(latitude AS float) AS latitude,
           CAST(longitude AS float) AS longitude
      FROM airport_raw;

DROP TABLE IF EXISTS plane;

CREATE TABLE plane STORED AS PARQUET AS
    SELECT tailnum AS tail_number,
           type, manufacturer, 
           CAST(from_unixtime(unix_timestamp( issue_date, 'MM/dd/yyyy'), 
							  'yyyy-MM-dd') AS date) AS issue_date,
           model, status, aircraft_type, engine_type,
           CAST(year AS int) AS year
      FROM plane_raw;

DROP TABLE IF EXISTS flight;

CREATE TABLE flight STORED AS PARQUET AS
    SELECT CAST(CONCAT(year,'-',LPAD(month,2,'0'),'-',
					   LPAD(day_of_month,2,'0')) AS date) AS flight_date,
           CAST(day_of_week AS int),
           LPAD(dep_time,4,'0') AS dep_time, 
           LPAD(arr_time,4,'0') AS arr_time,
           unique_carrier, flight_num, tail_num,
           CAST(elapsed_time AS int),
           CAST(air_time     AS int),
           CAST(arr_delay    AS int),
           CAST(dep_delay    AS int),
           origin, dest,
           CAST(distance     AS int),
           CAST(taxi_in      AS int),
           CAST(taxi_out     AS int),
           CAST(cancelled    AS int),
           cancellation_code,
           CAST(diverted     AS int)
      FROM flight_raw;
