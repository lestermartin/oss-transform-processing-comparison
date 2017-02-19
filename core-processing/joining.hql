SELECT F.*, P.year AS plane_built 
  FROM flight F, plane P 
 WHERE F.tail_num = P.tail_number;
