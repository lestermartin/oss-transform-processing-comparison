book_catalog = LOAD '/otpc/ff/json/data/catalog.json' 
    USING JsonLoader('title:chararray, author:chararray, price:float, year:int');
    
DESCRIBE book_catalog;
DUMP book_catalog;
