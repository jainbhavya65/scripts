#!/bin/bash
for x in {0..10000}
do
echo "create database mysql"$x";" >> mysql.sql
echo "create table mysql"$x".table1(name varchar(255));" >> mysql.sql
echo "create table mysql"$x".table2(name varchar(255));" >> mysql.sql
echo "create table mysql"$x".table3(name varchar(255));" >> mysql.sql
echo "create table mysql"$x".table4(name varchar(255));" >> mysql.sql
done

