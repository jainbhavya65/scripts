#!/bin/bash
projectname=$(zenity --list $(gcloud projects list | awk '{print $1}' | tail -n +2) --column "select project" ) 
y=$(echo "set")
gcloud config $y project $projectname
cluster_list=$(zenity --list $(gcloud container clusters list | awk '{print $1}' | tail -n +2) --column "select project")
zenity --info --text="Selected Cluster Name: "$cluster_list
gcloud container clusters get-credentials $cluster_list
