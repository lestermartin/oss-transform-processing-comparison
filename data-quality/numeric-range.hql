DROP TABLE IF EXISTS partial_airport_validated;

CREATE TABLE partial_airport_validated STORED AS ORC AS
    SELECT *
      FROM partial_airport_converted
     WHERE latitude  BETWEEN  -80 AND 70 
       AND longitude BETWEEN -170 AND 180;
