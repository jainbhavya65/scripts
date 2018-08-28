#!/bin/bash
exit1()
{
if [ $? == "1" ]
then
exit 1
fi
}
projectname=$(zenity --list $(gcloud projects list | awk '{print $1}' | tail -n +2) --column "select project" 2> /dev/null ) 
exit1
y=$(echo "set")
gcloud config $y project $projectname
cluster_list=$(zenity --list $(gcloud container clusters list | awk '{print $1}' | tail -n +2) --column "select Cluster" 2> /dev/null)
exit1
zenity --info --text="Selected Cluster Name: "$cluster_list
gcloud container clusters get-credentials $cluster_list
