DROP TABLE IF EXISTS target_airport;

CREATE TABLE target_airport STORED AS ORC AS
    SELECT airport_code AS airport_cd, airport AS name,
           city, state, country,
           'FAA' AS governing_agency
      FROM airport_raw;

--DESC target_airport;
--SELECT * FROM target_airport LIMIT 5;
