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
dir_temp=()
for x in {0..3}
do
dir_temp[$x]="dir[$x]$"${dir[$x]} 
done
echo ${dir_temp[@]} > /tmp/api_folder_status
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
if [ -s "/tmp/api_folder_status" ]
then
i=0
dir=()
for x in $(cat /tmp/api_folder_status)
do
y=$(echo $x |cut -d '$' -f2)
if [ -z $y ]
then
dir[$i]=$HOME
else
dir[$i]=$y
fi
i=`expr $i + 1`
done
if [ $option == "Git_Pull" ]
then
zenity --question --title "Path for Git_Pull" --text=${dir[0]}" \n Want to change Are you sure?" --cancel-label="Browse" 2> /dev/null
if [ $? == "1" ]
then
dir[0]=$(zenity --title="Select Path for Git_Pull" --file-selection --directory 2> /dev/null)
exit1
fi
fi
if [ $option == "Change_Backend_Config" ]
then
zenity --question --title "Path for Change_Backend_Config" --text=${dir[1]}" \n Want to change Are you sure?" --cancel-label="Browse" 2> /dev/null
if [ $? == "1" ]
then
dir[1]=$(zenity --title="Select Path for Change_Backend_Config" --file-selection --directory 2> /dev/null)
exit1
fi
fi
if [ $option == "Change_Docker_Version" ]
then
zenity --question --title "Path for Change_Docker_Version" --text=${dir[2]}" \n Want to change Are you sure?" --cancel-label="Browse" 2> /dev/null
if [ $? == "1" ]
then
dir[2]=$(zenity --title="Select Path for Change_Docker_Version" --file-selection --directory 2> /dev/null)
exit1
fi
fi
if [ $option == "Git_Push" ]
then
zenity --question --title "Path for Git_Push" --text=${dir[3]}" \n Want to change Are you sure?" --cancel-label="Browse" 2> /dev/null
if [ $? == "1" ]
then
dir[3]=$(zenity --title="Select Path for Git_Push" --file-selection --directory 2> /dev/null)
exit1
fi
fi
else
dir=($HOME $HOME $HOME $HOME)
case $option in
"Git_Pull")
dir[0]=$(zenity --title="Select Path for Git_Pull" --file-selection --directory 2> /dev/null)
exit1 ;;
"Change_Backend_Config")
dir[1]=$(zenity --title="Select path for Change_Backend_Config" --file-selection --directory 2> /dev/null)
exit1 ;;
"Change_Docker_Version")
dir[2]=$(zenity --title="Select Path for Change_Docker_Version" --file-selection --directory 2> /dev/null)
exit1 ;;
"Git_Push")
dir[3]=$(zenity --title="Select Path for Git_Push" --file-selection --file-selection --directory 2> /dev/null)
exit1 ;;
esac
fi
}
##################################################################################################
app_js()
{
dir_selection
cd ${dir[1]}
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
cd ${dir[2]}
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
cd ${dir[3]}
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
cd ${dir[0]}
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

