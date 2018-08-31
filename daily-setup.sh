#!/bin/bash
if [ -s "/tmp/daily_folder_status" ]
then
i=0
dir=()
for x in $(cat /tmp/daily_folder_status)
do
dir[$i]=$x
i=`expr $i + 1`
done
else
dir=()
dir[0]=$(zenity --title="Select directory1" --file-selection)
dir[1]=$(zenity --title="Select directory1" --file-selection)
dir[2]=$(zenity --title="Select directory1" --file-selection)
dir[3]=$(zenity --title="Select directory1" --file-selection)
echo ${dir[@]} > /tmp/daily_folder_status
fi
cmd1="echo ${dir[0]}"
cmd2="echo ${dir[1]}"
cmd3="echo ${dir[2]}"
cmd4="echo ${dir[3]}"
option=$(zenity --list --checklist false "1" false "2" false "3" false "4" --column "mark" --column "Select Option" 2> /dev/null)
case $option in 
	1)
	gnome-terminal --tab --command="bash -c '$cmd1; sleep 100'" 
	;;
	2)
	gnome-terminal --tab --command="bash -c '$cmd2; sleep 100'"
	;;
	3)
	gnome-terminal --tab --command="bash -c '$cmd3; sleep 100'" 
	;;
	4)	
	gnome-terminal --tab --command="bash -c '$cmd3; sleep 100'" 
	;;
	"1|2")
	 gnome-terminal --tab --command="bash -c '$cmd1; sleep 100'" --tab --command="bash -c '$cmd2; sleep 100'"
	;;
	"1|3")
	gnome-terminal --tab --command="bash -c '$cmd1; sleep 100'" --tab --command="bash -c '$cmd3; sleep 100'"
        ;;
	"1|4")
         gnome-terminal --tab --command="bash -c '$cmd1; sleep 100'" --tab --command="bash -c '$cmd4; sleep 100'"
        ;;
	"2|3")
         gnome-terminal --tab --command="bash -c '$cmd2; sleep 100'" --tab --command="bash -c '$cmd4; sleep 100'"
        ;;
	"2|4")
         gnome-terminal --tab --command="bash -c '$cmd2; sleep 100'" --tab --command="bash -c '$cmd4; sleep 100'"
        ;;
	"3|4")
         gnome-terminal --tab --command="bash -c '$cmd3; sleep 100'" --tab --command="bash -c '$cmd4; sleep 100'"
        ;;
	"1|2|3")
         gnome-terminal --tab --command="bash -c '$cmd1; sleep 100'" --tab --command="bash -c '$cmd2; sleep 100'" --tab --command="bash -c '$cmd3; sleep 100'"
        ;;
	"1|3|4")
         gnome-terminal --tab --command="bash -c '$cmd1; sleep 100'" --tab --command="bash -c '$cmd3; sleep 100'" --tab --command="bash -c '$cmd4; sleep 100'"
        ;;
	"2|3|4")
         gnome-terminal --tab --command="bash -c '$cmd2; sleep 100'" --tab --command="bash -c '$cmd3; sleep 100'" --tab --command="bash -c '$cmd4; sleep 100'"
        ;;
        "1|2|3|4")
	gnome-terminal --tab --command="bash -c '$cmd1; sleep 100'" --tab --command="bash -c '$cmd2; sleep 100'" --tab --command="bash -c '$cmd3; sleep 100'" --tab --command="bash -c '$cmd4; sleep 100'"
	;;
esac

