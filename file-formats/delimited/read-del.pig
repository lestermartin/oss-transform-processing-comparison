book_catalog = LOAD '/otpc/ff/del/data/catalog.del' USING PigStorage('|')
  AS (title:chararray, author:chararray, price:float, year:int);
    
DESCRIBE book_catalog;
DUMP book_catalog;
