#!/bin/bash
#########################################################################################
exit1()
{
if [ $? == "1" ]
then
echo $Status > done_task
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
option=$( zenity --list --column "Select Process" --column "Status" "config.development.ts" "${Status[0]}" "Server.js" "${Status[1]}" "Client_Production_Build" "${Status[2]}" "Edit_App.yaml" "${Status[3]}" "Gulp_Build" "${Status[4]}" "Git_Push" "${Status[5]}" 2> /dev/null)
exit1
}
##################################################################################################
Done()
{
zenity --text-info --filename="done_task" 2> /dev/null
exit1
}
###################################################################################################
config_development()
{
file1=$(zenity --file-selection --title="Select config.development.ts " 2> /dev/null)
exit1
config=$(echo $file1 | awk -F/ '{print $NF}')
if [ $config == "config.development.ts" ]
then
local_prod
if [ $prod_local == "Production" ]
then
sed -e "/apiUrl: 'http:/ s|^|//|" -e "/apiUrl: 'https:/ s|^/.*.apiUrl|apiUrl|" -i $file1
gnome-terminal -x bash -c "cat $file1 && sleep 3"
elif [ $prod_local == "Local" ]
then
sed -i -e "/apiUrl: 'http:/ s|^/.*.apiUrl|apiUrl|" -e "/apiUrl: 'https:/ s|^|//|" $file1
gnome-terminal -x bash -c "cat $file1 && sleep 3"
fi
else
zenity --title "Worng File Selected"  --error --text="Please Select config.development.ts File" 2> /dev/null
config_development
fi
Status[0]="Done"
}
###################################################################################################
server_js()
{
file2=$(zenity --file-selection --title="Select Sever.js" 2> /dev/null)
exit1
server=$(echo $file2 | awk -F/ '{print $NF}')
if [ $server == "server.js" ]
then
local_prod
if [ $prod_local == "Production" ]
then
sed -i "s|process.env.NODE_ENV = 'development'|process.env.NODE_ENV = 'production'|" $file2
gnome-terminal -x bash -c "cat server.js | grep -i process.env && sleep 5"
elif [ $prod_local == "Local" ]
then
sed -i "s|process.env.NODE_ENV = 'production'|process.env.NODE_ENV = 'development'|" $file2
gnome-terminal -x bash -c "cat $file2 | grep -i process.env && sleep 5"
fi
else 
zenity --title "Worng File Selected"  --error --text="Please Select server.js File" 2> /dev/null
server_js
fi
Status[1]="Done"
}
###################################################################################################
Production_build()
{
directory1=$(zenity --file-selection --directory --title="Select Production Build directory" 2> /dev/null)
exit1
cd $directory1
gnome-terminal -x bash -c "node --max_old_space_size=12288 ./node_modules/@angular/cli/bin/ng build --prod"
Status[2]="Done"
}
###################################################################################################
app_yaml()
{
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
else
sed -i "s|index.docker.io/itsolvs/bloomer-app:$version|index.docker.io/itsolvs/bloomer-app:$new_version|" $file3
gnome-terminal -x bash -c "cat app.yaml | grep -i index.docker.io && sleep 3"
fi
fi
Status[3]="Done"
}
###########################################################################################################
gulp_build()
{
directory2=$(zenity --file-selection --directory --title="Gulp Build Directory" 2> /dev/null)
exit1
cd $directory2
gnome-terminal -x bash -c "gulp build"
Status[4]="Done"
}
###########################################################################################################
git_push()
{
if [ -z $directory2 ]
then
directory3=$(zenity --file-selection --directory --title="Directory For Git Push" 2> /dev/null)
cd $directory3
exit1
fi
git_in=$(zenity --forms --title="Git" --add-entry="Comment For Commit" --add-entry="Branch Name" 2> /dev/null)
exit1
IFS="|" read -r comment branch  <<< "$git_in"
git add .
git commit -m $comment
cred_type=$(zenity --list "BY_SSH" "BY_Credentials" --column "Select Method" 2> /dev/null)
exit1
if [ $cred_type == "BY_SSH" ]
then
gnome-terminal -x bash -c "git push origin $branch && sleep 5"
elif [ $cred_type == "BY_Credentials" ]
then
user=$(zenity --password --username 2> /dev/null)
IFS="|" read -r username password   <<< "$user";
if [[ -z $username  ]] || [[ -z $password ]]
then
zenity --error --text="Please Enter Username and Password" 2> /dev/null
else
gnome-terminal -x bash -c "git push https://$username:$password@github.com/jainbhavya65/scripts.git $branch && sleep 5" 
fi
fi
Status[5]="Done"
}
###########################################################################################################
touch done_task
Status=(Not_Done Not_Done Not_Done Not_Done Not_Done Not_Done)
while [ $? == "0" ]
do
Popup
exit1
###########################
if [ $option == "config.development.ts" ]
then
if [ ${Status[0]} == "Done" ]
then 
zenity --question --text="do it already" --ok-label="Again" --cancel-label="ok" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      config_development ;;
esac
else
config_development
fi
fi
############
if [ $option == "Server.js" ]
then
if grep -Fxq "$option" done_task
then
zenity --question --text="do it already" --ok-label="Again" --cancel-label="ok" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      server_js ;;
esac
else
server_js
fi
fi
###########
if [ $option == "Client_Production_Build" ]
then
if grep -Fxq "$option" done_task
then
zenity --question --text="do it already" --ok-label="Again" --cancel-label="ok" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      Production_build ;;
esac
else
Production_build
fi
fi
###########
if [ $option == "Edit_App.yaml" ]
then
if grep -Fxq "$option" done_task
then
zenity --question --text="do it already" --ok-label="Again" --cancel-label="ok" 2> /dev/null
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
if [ $option == "Gulp_Build" ]
then
if grep -Fxq "$option" done_task
then
zenity --question --text="do it already" --ok-label="Again" --cancel-label="ok" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      gulp_build ;;
esac
else
gulp_build
fi
fi
##########
if [ $option == "Git_Push" ]
then 
if grep -Fxq "$option" done_task
then
zenity --question --text="do it already" --ok-label="Again" --cancel-label="ok" 2> /dev/null
case $? in
    "1")
      Popup ;;
    "0")
      git_push ;;
esac
else
echo  Git_Push >> done_task
git_push
fi
fi
done
