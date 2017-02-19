all_flights  = LOAD 'flight'  
    USING org.apache.hive.hcatalog.pig.HCatLoader();

--drop cols that are not needed for performance
reqd_flight_cols = FOREACH all_flights GENERATE
    origin, dep_delay, taxi_out;
    
flights_by_orig = GROUP reqd_flight_cols BY origin;

orig_timings = FOREACH flights_by_orig GENERATE
    group AS origin, 
    AVG(reqd_flight_cols.dep_delay) AS avg_dep_delay, 
    AVG(reqd_flight_cols.taxi_out)  AS avg_taxi_out;

sorted_orig_timings = ORDER orig_timings BY
    avg_dep_delay DESC;
    
top5_delays = LIMIT sorted_orig_timings 5;
DUMP top5_delays;
