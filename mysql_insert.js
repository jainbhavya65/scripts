#!/bin/bash
for x in {0..10000}
do 
echo "insert into mysql"$x".table1 values ('a'),('b'),('c'),('d'),('w'),('qp'),('ss'),('asa'),('asd'),('azs'),('adfa'),('aksa'),('asa'),('saqa'),('erfa'),('lasa');" >> mysql_insert.sql
echo "insert into mysql"$x".table2 values ('a'),('b'),('c'),('d'),('w'),('qp'),('ss'),('asa'),('asd'),('azs'),('adfa'),('aksa'),('asa'),('saqa'),('erfa'),('lasa');" >> mysql_insert.sql
echo "insert into mysql"$x".table3 values ('a'),('b'),('c'),('d'),('w'),('qp'),('ss'),('asa'),('asd'),('azs'),('adfa'),('aksa'),('asa'),('saqa'),('erfa'),('lasa');" >> mysql_insert.sql
echo "insert into mysql"$x".table4 values ('a'),('b'),('c'),('d'),('w'),('qp'),('ss'),('asa'),('asd'),('azs'),('adfa'),('aksa'),('asa'),('saqa'),('erfa'),('lasa');" >> mysql_insert.sql
done
