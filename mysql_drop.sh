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
selection=$(zenity --list --checklist --column "" --column  "Action Perform on" "" Database "" User 2> /dev/null)
exit1
if [ $selection == "Database" ]
then
	Database=$selection
elif [ $selection == "User" ]
then
	User=$selection
else
IFS="|" read -r Database User <<< "$selection"
fi
if [ ! -z  $Database ]
then
databases=$(gcloud sql databases list -i $instance | grep -i  iface_crm_user | awk '{print $1}')
if [ -z $databases ]
then
	zenity --info --text="No User Database exist" 2> /dev/null
else
for drop in $databases
do
echo "drop database" $drop";" >> mysql_drop.sql
done
fi
fi
if [ ! -z  $User ]
then
user=$(gcloud sql users list -i $instance | grep -i iface_crm_user| awk '{print $1}')
if [ -z $user ]
then
	zenity --info --text="No Client User exist" 2> /dev/null
else
for dropuser in $user
do
echo "drop user" $dropuser "@'%'">> mysql_drop.sql
done
fi
fi
if [ -z $user ] && [ -z $databases ]
then
	exit 1
fi
zenity --text-info --filename=./mysql_drop.sql
zenity --question
exit1
gsutil cp mysql_drop.sql gs://crm-remove-databse-user/
service_account=$(gcloud sql instances describe $instance | grep serviceAccountEmailAddress | awk -F ':' '{print $2}')
gsutil acl ch -u $service_account:W gs://crm-remove-databse-user/
gsutil acl ch -u $service_account:R gs://crm-remove-databse-user/mysql_drop.sql
gcloud sql import sql $instance gs://crm-remove-databse-user/mysql_drop.sql
rm -rf mysql_drop.sql
