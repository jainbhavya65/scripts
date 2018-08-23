#!/bin/bash
projectname=$(zenity --list $(gcloud projects list | awk '{print $1}' | tail -n +2) --column "select project" --title "Select Project" 2> /dev/null ) 
y=$(echo "set")
gcloud config $y project $projectname 2> /dev/null
cluster_list=$(zenity --list all --list $(gcloud container clusters list | awk '{print $1}' | tail -n +2) --column "select project" --title "Slect Cluster" 2> /dev/null)
    if [ $cluster_list != "all" ]
      then
         zenity --info --timeout=5 --text="Selected Cluster Name: "$cluster_list 2> /dev/null
         pool_list=$(gcloud container  node-pools list --cluster $cluster_list| awk '{print $1}' | tail -n +2)
         pool_name=$(gcloud container  node-pools describe $pool_list --cluster $cluster_list | grep compute/v1 | awk -F '/' '{print $11}'|awk -F '-' '{print $2"-"$3"-"$4}')
         #gcloud container clusters update $cluster_list --no-enable-autoscaling
         nodes_name=$(gcloud compute instances list | awk '{print $1}'| grep -i $pool_name)
         for z in $nodes_name
         do   
         #gcloud compute instances stop $z
         zenity --info --timeout=5 --text="Instance is down: "$z 2> /dev/null
 	 done
   elif [ $cluster_list == "all" ]
	then
        zenity --info --timeout=5 --text="Selected Cluster Name: ALL cluster are going to down" 2> /dev/null
         #gcloud container clusters update $v  --no-enable-autoscaling
        node_all=$(gcloud compute instances list | awk '{print $1}' | tail -n +2)
          for z in $node_all
          do
           zenity --info --timeout=5 --text="Instance is Down: "$z 2> /dev/null
           #gcloud compute instances stop $z
          done
fi
