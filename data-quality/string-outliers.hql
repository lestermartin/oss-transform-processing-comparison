SELECT airport_code, city
  FROM airport_raw
 WHERE LENGTH(TRIM(city)) > 30;
