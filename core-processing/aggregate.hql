SELECT origin, 
       AVG(dep_delay) AS avg_dep_delay, 
       AVG(taxi_out) AS avg_taxi_out 
  FROM flight 
 GROUP BY origin 
 ORDER BY avg_dep_delay DESC 
 LIMIT 5;
