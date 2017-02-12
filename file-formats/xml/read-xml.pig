REGISTER 'hdfs:///tmp/piggybank.jar';
DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath();
 
raw =  LOAD '/otpc/ff/xml/catalog.xml' 
   USING org.apache.pig.piggybank.storage.XMLLoader('BOOK') AS (x:chararray);

formatted = FOREACH raw GENERATE 
           XPath(x, 'BOOK/TITLE')  AS title, 
           XPath(x, 'BOOK/AUTHOR') AS author,
   (float) XPath(x, 'BOOK/PRICE')  AS price, 
     (int) XPath(x, 'BOOK/YEAR')   AS year;

DESCRIBE formatted;
DUMP formatted;
