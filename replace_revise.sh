#!/bin/bash
#########################################################################################
exit1()
{
if [ $? == "1" ]
then
exit 1
fi
}
##################################################################################################
Popup()
{
option=$(zenity --list "config.development.ts" "Server.js" "Client_Production_Build" "Edit_App.yaml" "Gulp_Build" "Git_Push" --column "Select Process")
}
###################################################################################################
config_development()
{
file1=$(zenity --file-selection --title="Select config.development.ts " 2> /dev/null)
exit1
config=$(echo $file1 | awk -F/ '{print $NF}')
if [ $config == "config.development.ts" ]
then
sed -i -e "s|apiUrl: 'http://localhost:7000/'|// apiUrl: 'http://localhost:7000/'|" -e "s|// apiUrl: 'https://crm-api.iface.io/'|apiUrl: 'https://crm-api.iface.io/'|" $file1
fi
Popup
exit1
}
###################################################################################################
server_js()
{
file2=$(zenity --file-selection --title="Select Sever.js" 2> /dev/null)
exit1
server=$(echo $file2 | awk -F/ '{print $NF}')
if [ $server == "server.js" ]
then
sed -i "s|process.env.NODE_ENV = 'development'|process.env.NODE_ENV = 'production'|" $file2
fi
Popup
exit1
}
###################################################################################################
Production_build()
{
directory1=$(zenity --file-selection --directory 2> /dev/null)
exit1
cd $directory1
for x in $(node --max_old_space_size=12288 ./node_modules/@angular/cli/bin/ng build --prod); do echo "# $x";sleep 0.1s; done | zenity --progress   --title="Production Build"   --text="Production code Building..." --percentage=0 --auto-close  --pulsate --no-cancel
exit1
Popup
exit1
}
###################################################################################################
app_yaml()
{
file3=$(zenity --file-selection 2> /dev/null)
exit1
app=$(echo $file3 | awk -F/ '{print $NF}')
echo $app
if [ $app == "app.yaml" ]
then
version=$(cat $file3 | grep -i image: | awk -F: {'print $3'})
echo $version
new_version=$(zenity --entry --title="Version Intake" --text="Current Version: "$version )
echo $new_version
sed -i "s|index.docker.io/itsolvs/bloomer-app:$version|index.docker.io/itsolvs/bloomer-app:$new_version|" $file3
fi
Popup
exit1
}
###########################################################################################################
gulp_build()
{
directory2=$(zenity --file-selection --directory 2> /dev/null)
exit1
cd $directory2
for x in $(gulp build); do echo "# $x";sleep 0.1s; done | zenity --progress   --title="Production Build"   --text="Production code Building..." --percentage=0 --auto-close  --pulsate --no-cancel
exit1
Popup
exit1
}
###########################################################################################################
git_push()
{
if [ -z $directory2 ]
then
directory3=$(zenity --file-selection --directory 2> /dev/null)
exit1
fi
git_in=$(zenity --form --add-entry="Comment For Commit" --add-entry="Branch Name" 2> /dev/null)
exit1
IFS="|" read -r comment branch  <<< "$git_in"
git add .
git commit -m $comment
#user=$(zenity --password --username 2> /dev/null)
#IFS="|" read -r username password   <<< "$user"
for x in $(git push origin $branch); do echo "# $x";sleep 0.1s; done  | zenity --progress --title="Git Push" --text="Pushing" --pulsate --auto-close --no-cancel
exit1
}
###########################################################################################################
Popup
exit1
echo $option
############
if [ $option == "config.development.ts" ]
then
config_development
fi
############
if [ $option == "Server.js" ]
then
server_js
fi
###########
if [ $option == "Client_Production_Build" ]
then
Production_build
fi
###########
if [ $option == "Edit_App.yaml" ]
then
app_yaml
fi
##########
if [ $option == "Gulp_Build" ]
then
gulp_build
fi
##########
if [ $option == "Git_Push" ]
then 
git_push
fi
