set hive.mapred.mode=nonstrict;
set hive.optimize.skewjoin.compiletime = true;
set hive.auto.convert.join=true;

CREATE TABLE T1_n29(key STRING, val STRING) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/T1.txt' INTO TABLE T1_n29;

CREATE TABLE T2_n20(key STRING, val STRING) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/T2.txt' INTO TABLE T2_n20;

CREATE TABLE T3_n7(key STRING, val STRING)
SKEWED BY (val) ON ((12)) STORED AS TEXTFILE;

LOAD DATA LOCAL INPATH '../../data/files/T3.txt' INTO TABLE T3_n7;

-- copy from skewjoinopt13
-- test compile time skew join and auto map join
-- This test is for skewed join compile time optimization for more than 2 tables.
-- The join key for table 3 is different from the join key used for joining
-- tables 1 and 2. Table 3 is skewed, but since one of the join sources for table
-- 3 consist of a sub-query which contains a join, the compile time skew join 
-- optimization is not performed
-- adding a order by at the end to make the results deterministic

EXPLAIN
select *
from 
T1_n29 a join T2_n20 b on a.key = b.key 
join T3_n7 c on a.val = c.val;

select *
from 
T1_n29 a join T2_n20 b on a.key = b.key 
join T3_n7 c on a.val = c.val
order by a.key, b.key, c.key, a.val, b.val, c.val;

