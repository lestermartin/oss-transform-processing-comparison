source_airport = LOAD 'airport_raw' 
    USING org.apache.hive.hcatalog.pig.HCatLoader();
    
source_airport_no_hdr = FILTER source_airport
    BY airport_code != 'iata';  --lose the header row
 
-- convert data types
source_airport_converted = FOREACH source_airport_no_hdr GENERATE
    airport_code, (float) latitude, (float) longitude;
    
-- get rid of values that did not convert properly
source_airport_not_null = FILTER source_airport_converted BY 
    ( NOT ( (latitude IS NULL) OR (longitude IS NULL) ) );
    
-- get rid of non-valid coordinates 
source_airport_validated = FILTER source_airport_not_null BY
    (latitude <= 70) AND (longitude >= -170);

-- count the collection Pig's way...
valid_grouped = GROUP source_airport_validated ALL;
valid_count = FOREACH valid_grouped GENERATE 
    'tot_not_null', COUNT(source_airport_validated);
dump valid_count;
