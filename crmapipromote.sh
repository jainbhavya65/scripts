#!/bin/bash
# resizes the window to full height and 50% width and moves into upper right corner

#define the height in px of the top system-bar:
TOPMARGIN=27

#sum in px of all horizontal borders:
RIGHTMARGIN=10

# get width of screen and height of screen
SCREEN_WIDTH=$(xwininfo -root | awk '$1=="Width:" {print $2}')
SCREEN_HEIGHT=$(xwininfo -root | awk '$1=="Height:" {print $2}')

# new width and height
W=$(( $SCREEN_WIDTH / 2 - $RIGHTMARGIN ))
H=$(( $SCREEN_HEIGHT - 2 * $TOPMARGIN ))
#########################################################################################
exit1()
{
if [ $? == "1" ]
then
echo ${Status[@]} > /tmp/api_done_task
exit 1
fi
}
##################################################################################################
local_prod()
{
prod_local=$(zenity --list "Production" "Local" --column "Where want to run" 2> /dev/null)
exit1
}
##################################################################################################
Popup()
{
option=$( zenity --list --column "Select Process" --column "Status" "Git_Pull" "${Status[0]}"  "Change_Backend_Config" "${Status[1]}" "Change_Docker_Version" "${Status[2]}"  "Git_Push" "${Status[3]}" --width=$W --height=$H 2> /dev/null)
exit1
}
##################################################################################################
dir_selection()
{
if [ ! -s "/tmp/api_folder_status" ]
then
echo "Git_Pull:" >> /tmp/api_folder_status
echo "Change_Backend_Config:" >> /tmp/api_folder_status
echo "Change_Docker_Version:" >> /tmp/api_folder_status
echo "Git_Push:" >> /tmp/api_folder_status
fi
}
##################################################################################################
app_js()
{
dir_selection
dir1=$(cat /tmp/api_folder_status | grep "Change_Backend_Config:"| cut -d ':' -f2  )
if [ -z $dir1 ]
then
dir11=$(zenity --title="Select path for Change_Backend_Config" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Change_Backend_Config:|Change_Backend_Config:$dir11|g" /tmp/api_folder_status
cd $dir11
else
dir12=$(zenity --question --title="Change_Backend_Config Directory" --text=$dir1"\n Do you want to change?" --ok-label="Browse" 2> /dev/null)
if [ $? == "0" ]
then
dir13=$(zenity --title="Select path for Change_Backend_Config" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Change_Backend_Config:|Change_Backend_Config:$dir13|g" /tmp/api_folder_status
fi
cd $dir1
fi
file2=$(zenity --file-selection --title="Select app.js" 2> /dev/null)
exit1
server=$(echo $file2 | awk -F/ '{print $NF}')
if [ $server == "app.js" ]
then
local_prod
if [ $prod_local == "Production" ]
then
sed -i "s|process.env.NODE_ENV = 'development'|process.env.NODE_ENV = 'production'|" $file2
gnome-terminal -x bash -c "cat server.js | grep -i process.env && sleep 1"
Status[1]="Done"
elif [ $prod_local == "Local" ]
then
sed -i "s|process.env.NODE_ENV = 'production'|process.env.NODE_ENV = 'development'|" $file2
gnome-terminal -x bash -c "cat $file2 | grep -i process.env && sleep 1"
Status[1]="Done"
fi
else
zenity --title "Worng File Selected"  --error --text="Please Select app.js File" 2> /dev/null
app_js
fi
}
################################################################################################
app_yaml()
{
dir_selection
dir2=$(cat /tmp/api_folder_status | grep "Change_Docker_Version:"| cut -d ':' -f2  )
if [ -z $dir2 ]
then
dir21=$(zenity --title="Select path for Change_Docker_Version" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Change_Docker_Version:|Change_Docker_Version:$dir21|g" /tmp/api_folder_status
cd $dir21
else
dir22=$(zenity --question --title="Change_Docker_Version Directory" --text=$dir2"\n Do you want to change?" --ok-label="Browse" 2> /dev/null)
if [ $? == "0" ]
then
dir23=$(zenity --title="Select path for Change_Docker_Version" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Change_Docker_Version:|Change_Docker_Version:$dir23|g" /tmp/api_folder_status
fi
cd $dir2
fi
file3=$(zenity --file-selection --title="Select app.yaml" 2> /dev/null)
exit1
app=$(echo $file3 | awk -F/ '{print $NF}')
if [ $app == "app.yaml" ]
then
version=$(cat $file3 | grep -i image: | awk -F: {'print $3'})
new_version=$(zenity --entry --title="Version Intake" --text="Current Version: "$version 2> /dev/null )
if [ $version == "$new_version" ]
then
zenity --error --text="Same version Please change version" 2> /dev/null
Status[2]="Not_Done"
else
sed -i "s|index.docker.io/itsolvs/bloomer-app:$version|index.docker.io/itsolvs/bloomer-app:$new_version|" $file3
gnome-terminal -x bash -c "cat app.yaml | grep -i index.docker.io ; sleep 1000"
Status[2]="Done"
fi
fi
}
################################################################################################################
git_push()
{
dir_selection
dir3=$(cat /tmp/api_folder_status | grep "Git_Push:"| cut -d ':' -f2  )
if [ -z $dir3 ]
then
dir31=$(zenity --title="Select path for Git_Push" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Git_Push:|Git_Push:$dir31|g" /tmp/api_folder_status
cd $dir31
else
dir32=$(zenity --question --title="Git Push Directory" --text=$dir3"\n Do you want to change?" --ok-label="Browse" 2> /dev/null)
if [ $? == "0" ]
then
dir33=$(zenity --title="Select path for Git_Push" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Git_Push:|Git_Push:$dir33|g" /tmp/api_folder_status
fi
cd $dir3
fi
git_in=$(zenity --forms --title="Git" --add-entry="Comment For Commit" --add-entry="Branch Name" 2> /dev/null)
exit1
IFS="|" read -r comment branch  <<< "$git_in"
git add .
git commit -m "$comment"
cred_type=$(zenity --list "BY_SSH" "BY_Credentials" --column "Select Method" 2> /dev/null)
exit1
if [ $cred_type == "BY_SSH" ]
then
gnome-terminal -x bash -c 'git push origin $branch ; sleep 1000'
Status[3]="Done"
elif [ $cred_type == "BY_Credentials" ]
then
user=$(zenity --password --username 2> /dev/null)
IFS="|" read -r username password   <<< "$user";
if [[ -z $username  ]] || [[ -z $password ]]
then
zenity --error --text="Please Enter Username and Password" 2> /dev/null
else
gnome-terminal -x bash -c 'git push https://$username:$password@github.com/jainbhavya65/scripts.git $branch ; sleep 1000'
Status[3]="Done"
fi
fi
}
#############################################################################################################
git_pull()
{
dir_selection
dir4=$(cat /tmp/api_folder_status | grep "Git_Pull:"| cut -d ':' -f2  )
if [ -z $dir4 ]
then
dir41=$(zenity --title="Select path for Git_Pull" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Git_Pull:|Git_Pull:$dir41|g" /tmp/api_folder_status
cd $dir41
else
dir42=$(zenity --question --title="Git Pull Directory" --text=$dir4"\n Do you want to change?" --ok-label="Browse" 2> /dev/null)
if [ $? == "0" ]
then
dir43=$(zenity --title="Select path for Git_Push" --file-selection --directory 2> /dev/null)
exit1
sed -i "s|Git_Push:|Git_Push:$dir43|g" /tmp/api_folder_status
fi
cd $dir4
fi
pull_branch=$(zenity --forms --title="Git Pull" --add-entry="Branch Name" 2> /dev/null)
exit1
gnome-terminal -x bash -c 'git pull origin $pull_branch ; sleep 1000'
Status[0]="Done"
}
#############################################################################################################
all_done()
{
Done=()
for i in {0..3}
do
Done[$i]=Done
done
diff=$(diff <(printf "%s\n" "${Status[@]}") <(printf "%s\n" "${Done[@]}"))
if [[ -z "$diff" ]]
then
Status=(Not_Done Not_Done Not_Done Not_Done)
fi
}
#############################################################################################################
check_done_task()
{
if [ -s "/tmp/api_done_task" ]
then
i=0
Status=()
for x in $(cat /tmp/api_done_task)
do
Status[$i]=$x
i=`expr $i + 1`
done
else
Status=(Not_Done Not_Done Not_Done Not_Done)
fi
}
#############################################################################################################
check_done_task
all_done
while [ $? == "0" ]
do
Popup
exit1
############
if [ $option == "Change_Backend_Config" ]
then
if [ ${Status[1]} == "Done" ]
then
zenity --question --text="Are you sure want to edit again?" --title="Aready Done!" --ok-label="Yes" --cancel-label="No" 2> /dev/null
exit1
case $? in
    "1")
      Popup ;;
    "0")
      app_js ;;
esac
else
app_js
fi
fi
###########
if [ $option == "Change_Docker_Version" ]
then
if [ ${Status[2]} == "Done" ]
then
zenity --question --text="Are you sure want to edit again?" --title="Aready Done!" --ok-label="Yes" --cancel-label="No" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      app_yaml;;
esac
else
app_yaml
fi
fi
##########
if [ $option == "Git_Pull" ] || [ $option == "Git_Push" ] 
then
if [ $option == "Git_Push" ]
then
if [ ${Status[3]} == "Done" ]
then
zenity --question --text="Are you sure want to edit again?" --title="Aready Done!" --ok-label="Yes" --cancel-label="No" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      git_push ;;
esac
else
git_push
fi
elif [ $option == "Git_Pull" ]
then
if [ ${Status[0]} == "Done" ]
then
zenity --question --text="Are you sure want to edit again?" --title="Aready Done!" --ok-label="Yes" --cancel-label="No" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      git_pull ;;
esac
else
git_pull
fi
fi
fi
done
