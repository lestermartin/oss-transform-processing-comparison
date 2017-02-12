-- don't forget the include -useHCatalog parameter

source_airport = LOAD 'airport_raw' 
    USING org.apache.hive.hcatalog.pig.HCatLoader();

target_airport = FOREACH source_airport GENERATE 
    airport_code AS airport_cd, airport AS name,  --renames
    city, state, country, -- carry forwards
    -- don't mention those dropping (lat and long)
    'FAA' AS governing_agency:chararray;  -- hard coded 
    
DESCRIBE target_airport;
to_display = LIMIT target_airport 5;
DUMP to_display;
