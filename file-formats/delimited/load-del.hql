-- create the table mapped to location of pipe delimited file
DROP TABLE IF EXISTS book_catalog_pipe;

CREATE EXTERNAL TABLE book_catalog_pipe(
        title string, author string, price float, year int)
    ROW FORMAT DELIMITED
    FIELDS TERMINATED BY '|'
    STORED AS TEXTFILE
    LOCATION '/otpc/ff/del/data';

--DESC book_catalog_pipe;
--SELECT * FROM book_catalog_pipe;
