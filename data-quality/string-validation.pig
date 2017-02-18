source_airport = LOAD 'airport_raw' 
    USING org.apache.hive.hcatalog.pig.HCatLoader();
    
source_airport_no_hdr = FILTER source_airport
    BY airport_code != 'iata';  --lose the header row
    
long_city_names = FILTER source_airport_no_hdr BY
    SIZE(TRIM(city)) > 30;
    
DUMP long_city_names;

source_airport_validated = FOREACH source_airport_no_hdr GENERATE
    airport_code, airport,
    SUBSTRING(TRIM(city),0,29) AS city,
    state, country;
    
DESCRIBE source_airport_validated;
