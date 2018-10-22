#!/bin/bash
exit1()
{
if [ $? == "1" ]
then
exit 1
fi
}
select_Service=$(zenity --list "Cluster"  "Cloud SQL"  --width=600 --height=400 --title="Gcloud Services" --column="Select Service" 2> /dev/null)
exit1
if [ $select_Service=="Cluster" ]
then 
on_off=$(zenity --list "Cluster_On" "Cluster_Off" "Cluster_Switch" --column="Operation Perform" 2> /dev/null)
exit1
if [ $on_off=="Cluster_on" ]
then
bash /home/iface14/scripts/cluster_on_GUI.sh 
elif [ $on_off=="Cluster_Off" ]
then
bash /home/iface14/scripts/cluster_off_GUI.sh
elif [ $on_off=="Cluster_Switch" ]
then
bash /home/iface14/scripts/cluster_switch.sh
fi
fi
