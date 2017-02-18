DROP TABLE IF EXISTS partial_airport_validated;

CREATE TABLE partial_airport_validated STORED AS ORC AS
    SELECT airport_code, airport,
           SUBSTR(TRIM(city),1,30) AS city,
           state, country
      FROM airport_raw;
