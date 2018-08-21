#!/bin/bash
read -p 'Enter Instance name of Cloud SQL': instance
drop_database=$(gcloud sql databases list -i $instance | grep -i crm_user | awk '{print $1}')
drop_user=$(gcloud sql user list -i $instance | grep -i crm_user| awk '{print $1}')
for drop in drop_database
do 
echo "drop database" $drop";" >> mysql_drop.sql
done
for dropuser in drop_user
do 
echo "drop user" $dropuser "@'%'">> mysql_drop.sql
done
