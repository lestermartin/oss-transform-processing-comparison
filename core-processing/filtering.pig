all_airports = LOAD 'airport' 
    USING org.apache.hive.hcatalog.pig.HCatLoader();

tx_airports = FILTER all_airports BY state == 'TX';
DUMP tx_airports;
