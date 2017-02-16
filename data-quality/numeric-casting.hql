DROP TABLE IF EXISTS partial_airport_converted;

CREATE TABLE partial_airport_converted STORED AS ORC AS
    SELECT airport_code, 
           CAST(latitude AS float), 
           CAST(longitude AS float)
      FROM airport_raw;

-- check to see how many failed to convert to a number
SELECT airport_code 
  FROM partial_airport_converted
 WHERE latitude IS NULL OR longitude IS NULL;
