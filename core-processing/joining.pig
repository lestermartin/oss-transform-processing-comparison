all_flights = LOAD 'flight' USING org.apache.hive.hcatalog.pig.HCatLoader();
all_planes  = LOAD 'plane'  USING org.apache.hive.hcatalog.pig.HCatLoader();

with_year = JOIN all_flights BY tail_num, all_planes BY tail_number;
-- that generates a schema with all attributes from both aliases 
--     with each attribute prefixed by the originating alias name

prettier = FOREACH with_year GENERATE
    all_flights::flight_date AS flight_date,
    all_flights::day_of_week AS day_of_week,
    all_flights::tail_num    AS tail_num,
    -- and ALL the other 16 "all_flights" attributes 
    all_planes::year         AS year;
    -- can ignore the other 8 "all_planes" attributes
    
smaller = LIMIT prettier 15;

DUMP smaller;
