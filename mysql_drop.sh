#!/bin/bash
exit1()
{
if [ $? == "1" ]
then
exit 1
fi
}
instance=$(zenity --list --column "instance name" $(gcloud sql instances list | awk '{print $1}' | tail -n +2) 2> /dev/null)
exit1
#read -p 'Enter Instance name of Cloud SQL': instance
drop_database=$(gcloud sql databases list -i $instance | grep -i  iface_crm_user | awk '{print $1}')
drop_user=$(gcloud sql users list -i $instance | grep -i iface_crm_user| awk '{print $1}')
selection=$(zenity --list --checklist --column "" --column  "Action Perform on" "" Database "" User 2> /dev/null)
echo $selection
exit1
IFS="|" read -r Database User <<< $selection
if [ ! -z  $Database ]
then
for drop in $drop_database
do 
echo "drop database" $drop";" >> mysql_drop.sql
done
fi
if [ ! -z  $User ]
then
for dropuser in $drop_user
do 
echo "drop user" $dropuser "@'%'">> mysql_drop.sql
done
fi
gsutil cp mysql_drop.sql gs://crm-remove-databse-user/
service_account=$(gcloud sql instances describe $instance | grep serviceAccountEmailAddress | awk -F ':' '{print $2}')
gsutil acl ch -u $service_account:W gs://crm-remove-databse-user/
gsutil acl ch -u $service_account:R gs://crm-remove-databse-user/mysql_drop.sql
gcloud sql import sql $instance gs://crm-remove-databse-user/mysql_drop.sql
rm -rf mysql_drop.sql
