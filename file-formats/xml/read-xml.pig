REGISTER 'hdfs:///tmp/piggybank.jar';
DEFINE XPath org.apache.pig.piggybank.evaluation.xml.XPath();
 
raw =  LOAD '/otpc/ff/xml/catalog.xml' 
   USING org.apache.pig.piggybank.storage.XMLLoader('BOOK') AS (x:chararray);

formatted = FOREACH raw GENERATE 
           XPath(x, 'BOOK/TITLE'), 
           XPath(x, 'BOOK/AUTHOR'),
   (float) XPath(x, 'BOOK/PRICE'), 
     (int) XPath(x, 'BOOK/YEAR');

DESCRIBE formatted;
DUMP formatted;
