SELECT DISTINCT(aircraft_type) 
  FROM plane;

SELECT DISTINCT(manufacturer) 
  FROM plane 
 WHERE aircraft_type = 'Rotorcraft';
