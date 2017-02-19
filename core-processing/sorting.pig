all_airports = LOAD 'flight' USING org.apache.hive.hcatalog.pig.HCatLoader();

ordered_airports = ORDER all_airports BY 
    dep_delay DESC, unique_carrier, flight_num;
    
small_list = LIMIT ordered_airports 10;
DUMP small_list;
