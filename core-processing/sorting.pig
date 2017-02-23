all_airports = LOAD 'flight' USING org.apache.hive.hcatalog.pig.HCatLoader();

ordered_flights = ORDER all_flights BY 
    dep_delay DESC, unique_carrier, flight_num;
    
small_list = LIMIT ordered_flights 10;
DUMP small_list;
