#!/bin/bash
rm -f test.txt
rm -f cluster_no.txt
read -p "Enter Project Name:" projectname
#read -p "Enter No of Node(if you want to temporary down it just enter it 0):" resize
y=$(echo "set")
gcloud config $y project $projectname
cluster_list=$(gcloud container clusters list | awk '{print $1}' | tail -n +2)
for x in $cluster_list
do
echo $x >> test.txt
done
awk '{print NR,$0}' test.txt | tee cluster_no.txt
read -p "Enter Option(for down all Just Enter all):" o
    if [ $o != "all" ]
      then
         cluster=$(sed -sn  "$o"p cluster_no.txt | cut -d ' ' -f2)
         echo "Selected Cluster Name:" $cluster
         pool_list=$(gcloud container  node-pools list --cluster $cluster| awk '{print $1}' | tail -n +2)
         pool_name=$(gcloud container  node-pools describe $pool_list --cluster $cluster | grep compute/v1 | awk -F '/' '{print $11}'|awk -F '-' '{print $2"-"$3"-"$4}')
         gcloud container clusters update $cluster  --no-enable-autoscaling
         gcloud container node-pools update $(gcloud container node-pools list --cluster $cluster | awk {'print $1'} | tail -n +2) --cluster $cluster --no-enable-autorepair
         nodes_name=$(gcloud compute instances list | awk '{print $1}'| grep -i $pool_name)
          for z in $nodes_name
          do
           echo $z             
           gcloud compute instances stop $z
          done
   else
	echo "Selected Cluster Name: ALL cluster are going to down" 
         #gcloud container clusters update $v  --no-enable-autoscaling
         #gcloud container node-pools update $(gcloud container node-pools list --cluster $v | awk {'print $1'} | tail -n +2) --cluster $v  --no-enable-autorepair
        node_all=$(gcloud compute instances list | awk '{print $1}' | tail -n +2)
          for z in $node_all
          do
	   echo $z
           gcloud compute instances stop $z
          done
fi
