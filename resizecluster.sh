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

#while :
#do
# read -p "Enter Option(for down all Just Enter all):" option
# case $option in 
# 	1)
#	 cluster1=$(sed -sn 1p cluster_no.txt | cut -d " " -f2)
#	 echo "Selected Cluster Name:" $cluster1
#	 pool_list1=$(gcloud container  node-pools list --cluster $cluster1| awk '{print $1}' | tail -n +2)
#	 pool_name1=$(gcloud container  node-pools describe $pool_list1 --cluster $cluster1 | grep compute/v1 | awk -F '/' '{print $11}'|awk -F '-' '{print $2"-"$3"-"$4}')
#	 #gcloud container clusters update $(sed -sn 1p cluster_no.txt | cut -d " " -f2)  --no-enable-autoscaling
#         #gcloud container node-pools update $(gcloud container node-pools list --cluster $(sed -sn 1p cluster_no.txt | cut -d " " -f2) | awk {'print $1'} | tail -n +2) --cluster $(sed -sn 1p cluster_no.txt | cut -d " " -f2)  --no-enable-autorepair
#	 nodes_name1=$(gcloud compute instances list | awk '{print $1}'| grep -i $pool_name1)
#	  for z1 in $nodes_name1
#	  do 
#           echo $z1		
#	   #gcloud compute instances stop $z1
#	  done
#	 break	;;
# 	2)	
#	 cluster2=$(sed -sn 2p cluster_no.txt | cut -d " " -f2)
#	 echo "Selected Cluster Name:" $cluster2
#	 pool_list2=$(gcloud container  node-pools list --cluster $cluster2| awk '{print $1}' | tail -n +2)
#	 pool_name2=$(gcloud container  node-pools describe $pool_list2 --cluster $cluster2 | grep compute/v1 | awk -F '/' '{print $11}'|awk -F '-' '{print $2"-"$3"-"$4}')
#	 nodes_name2=$( gcloud compute instances list | awk '{print $1}' | grep -i $pool_name2 )
#         #gcloud container clusters update $(sed -sn 2p cluster_no.txt | cut -d " " -f2)  --no-enable-autoscaling
#         #gcloud container node-pools update $(gcloud container node-pools list --cluster $(sed -sn 2p cluster_no.txt | cut -d " " -f2) | awk {'print $1'} | tail -n +2) --cluster $(sed -sn 2p cluster_no.txt | cut -d " " -f2)  --no-enable-autorepair
#	  for z2 in $nodes_name2
#	  do 
#	   echo $z2
#	   gcloud compute instances stop $z2
#	  done
#	 break	;;
# 	3)
#	 cluster3=$(sed -sn 3p cluster_no.txt | cut -d " " -f2)
#	 echo "Selected Cluster Name:" $cluster3
#	 pool_list3=$(gcloud container  node-pools list --cluster $cluster3| awk '{print $1}' | tail -n +2)
#	 pool_name3=$(gcloud container  node-pools describe $pool_list3 --cluster $cluster3 | grep compute/v1 | awk -F '/' '{print $11}'|awk -F '-' '{print $2"-"$3"-"$4}') 
#         #gcloud container clusters update $(sed -sn 3p cluster_no.txt | cut -d " " -f2)  --no-enable-autoscaling
#         #gcloud container node-pools update $(gcloud container node-pools list --cluster $(sed -sn 3p cluster_no.txt | cut -d " " -f2) | awk {'print $1'} | tail -n +2) --cluster $(sed -sn 3p cluster_no.txt | cut -d " " -f2)  --no-enable-autorepair
#	 nodes_name3=$(gcloud compute instances list | awk '{print $1}'| grep -i $pool_name3)
#	  for z3 in $nodes_name3
#	  do 
#	   echo $z3	
#	   #gcloud compute instances stop $z3
#	  done
#	 break	;;
# 	4)
#	 cluster4=$(sed -sn 4p cluster_no.txt | cut -d " " -f2)
#	 echo "Selected Cluster Name:" $cluster3
#         #gcloud container clusters update $(sed -sn 4p cluster_no.txt | cut -d " " -f2)  --no-enable-autoscaling
#         #gcloud container node-pools update $(gcloud container node-pools list --cluster $(sed -sn 4p cluster_no.txt | cut -d " " -f2) | awk {'print $1'} | tail -n +2) --cluster $(sed -sn 4p cluster_no.txt | cut -d " " -f2)  --no-enable-autorepair
#	 nodes_name4=$(gcloud compute instances list | awk '{print $1}'| grep -i $pool_name4)
#	  for z4 in $nodes_name4
#	  do
#	   echo $z4 
#	   #gcloud compute instances stop $z4
#	  done
#	 break	;;
# 	5)
#	 cluster5=$(sed -sn 5p cluster_no.txt | cut -d " " -f2)
#	 echo "Selected Cluster Name:" $(sed -sn 5p cluster_no.txt | cut -d " " -f2)
# 	 #gcloud container clusters update $(sed -sn 5p cluster_no.txt | cut -d " " -f2)  --no-enable-autoscaling
#         #gcloud container node-pools update $(gcloud container node-pools list --cluster $(sed -sn 5p cluster_no.txt | cut -d " " -f2) | awk {'print $1'} | tail -n +2) --cluster $(sed -sn 5p cluster_no.txt | cut -d " " -f2)  --no-enable-autorepair
#	 nodes_name5=$(gcloud compute instances list | awk '{print $1}'| grep -i $pool_name5)
#	  for z5 in $nodes_name5
#	  do
#           echo $z5 
#	   #gcloud compute instances stop $z5
#	  done
#	 break	;;
#        all)
#	 echo "Selected Cluster Name: ALL cluster are going to down" 
#	 #gcloud container clusters update $v  --no-enable-autoscaling
#         #gcloud container node-pools update $(gcloud container node-pools list --cluster $v | awk {'print $1'} | tail -n +2) --cluster $v  --no-enable-autorepair
#        node_all=$(gcloud compute instances list)
#	  for z6 in $nodes_all
#	  do 
#	   gcloud compute instances stop $z6
#	  done
#	 break	;;
# esac
#done






#cluster_list=$(gcloud container clusters list | awk '{print $1}' | tail -n +2)

#for x in $cluster_list
#do
#echo $x
#gcloud container clusters resize --size=$resize $x --quiet
#echo $x "is down"
#done

