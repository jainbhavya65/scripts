#!/bin/bash
exit1()
{
if [ $? == "1" ]
then
exit 1
fi
}
selection=$(zenity --list --checklist --column "" --column  "Action Perform on" "" Database "" User 2> /dev/null)
echo $selection
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
databases=$(mysql -u root -p"Iface#@123!" -h 192.168.1.18 -P 3307 -e 'show databases;' | grep iface_crm_user 2> /dev/null)
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
user=$(mysql -u root -p"Iface#@123!" -h 192.168.1.18 -P 3307 -e 'select user from mysql.user;'| grep iface_crm_user 2> /dev/null)
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
zenity --text-info --filename=./mysql_drop.sql 2> /dev/null
exit1
zenity --question
exit1
mysql -u root -p"Iface#@123!" -h 192.168.1.18 -P 3307 < mysql_drop.sql 2> /dev/null
rm -rf mysql_drop.sql
