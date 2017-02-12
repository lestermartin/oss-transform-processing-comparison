-- create the table mapped to location of flattened json file(s)
DROP TABLE IF EXISTS book_catalog_json;

CREATE EXTERNAL TABLE book_catalog_json(
        title string, author string, price float, year int)
    ROW FORMAT SERDE 'org.apache.hive.hcatalog.data.JsonSerDe'
    STORED AS TEXTFILE
    LOCATION '/otpc/ff/json/data';

--DESC book_catalog_json;
--SELECT * FROM book_catalog_json;
