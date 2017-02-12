-- create the table mapped to loacation of flattened xml file(s)
DROP TABLE IF EXISTS book_catalog_xml;

CREATE EXTERNAL TABLE book_catalog_xml(str string)
    LOCATION '/otpc/ff/xml/flat';

-- convert the xml data into individual columns and create a new 
--    table or view of the results
DROP TABLE IF EXISTS book_catalog;

CREATE TABLE book_catalog STORED AS ORC AS
    SELECT xpath_string(str,'BOOK/TITLE')  AS title, 
           xpath_string(str,'BOOK/AUTHOR') AS author,
           xpath_float( str,'BOOK/PRICE')  AS price, 
           xpath_int(   str,'BOOK/YEAR')   AS year
      FROM book_catalog_xml;

DESC book_catalog;
SELECT * FROM book_catalog;
