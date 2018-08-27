#!/bin/bash
select_Service=$(zenity --list "Cluster"  "Cloud SQL"  --width=600 --height=400 --title="Gcloud Services" --column="Select Service" 2> /dev/null)
exit1
if [ $select_Service == "Cluster" ]
then 
on_off=$(zenity --list "Cluster_On" "Cluster_Off" --column="Operation Perform" 2> /dev/null)
exit1
if [ $on_off == "Cluster_on" ]
then
bash 
elif
then
fi
fi
