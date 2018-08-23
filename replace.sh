#!/bin/bash
exit1()
{
if [ $? == "1" ]
then
exit 1
fi
}
file1=$(zenity --file-selection 2> /dev/null)
exit1
file2=$(zenity --file-selection 2> /dev/null)
exit1
line1=$(zenity --forms --title="Replace in "$file1 --text="Replace Word" --add-entry="Line Number" --add-entry="Word" --add-entry="Replace Word" 2> /dev/null)
exit1
IFS="|" read -r line_no1 Word1 rWord1 <<< "$line1"
zenity --question --text="Enter values are: "$line_no1","$Word1","$rWord1 --title="Check"  2> /dev/null
exit1
line2=$(zenity --forms --title="Replace in "$file2 --text="Replace Word" --add-entry="Line Number" --add-entry="Word" --add-entry="Replace Word" 2> /dev/null)
exit1
IFS="|" read -r line_no2 Word2 rWord2 <<< "$line2"
zenity --question --text="Enter values are: "$line_no2","$Word2","$rWord2 --title="Check"  2> /dev/null
if [ -z "$line_no1"  ]
then
sed -i "s/$Word1/$rWord1/g" $file1
else
sed -i "$line_no1 s/$Word1/$rWord1/g" $file1
fi
if [ -z "$line_no2"  ]
then
sed -i "s/$Word2/$rWord2/g" $file2
else
sed -i "$line_no2 s/$Word2/$rWord2/g" $file2
fi
directory1=$(zenity --file-selection --directory 2> /dev/null)
exit1
cd $directory1
for x in $(node --max_old_space_size=12288 ./node_modules/@angular/cli/bin/ng build --prod); do echo "# $x";sleep 0.1s; done | zenity --progress   --title="Production Build"   --text="Production code Building..." --percentage=0 --auto-close  --pulsate
exit1
file3=$(zenity --file-selection 2> /dev/null)
exit1
line3=$(zenity --forms --title="Replace in "$file3 --text="Replace Word" --add-entry="Line Number" --add-entry="Word" --add-entry="Replace Word" 2> /dev/null)
exit1
IFS="|" read -r line_no3 Word3 rWord3 <<< "$line3"
zenity --question --text="Enter values are: "$line_no3","$Word3","$rWord3 --title="Check"  2> /dev/null
if [ -z "$line_no3"  ]
then
sed -i "s/$Word3/$rWord3/g" $file1
else
sed -i "$line_no3 s/$Word3/$rWord3/g" $file1
fi
directory2=$(zenity --file-selection --directory 2> /dev/null)
exit1
cd $directory2
gulp build | zenity --progress   --title="Production Build"   --text="Production code Building..." --percentage=0 --auto-close  --pulsate
exit1
git_in=$(zenity --form --add-entry="Comment For Commit" --add-entry="Branch Name" 2> /dev/null)
IFS="|" read -r comment branch  <<< "$git_in"
git add .
git commit -m $comment
user=$(zenity --password --username 2> /dev/null)
IFS="|" read -r username password   <<< "$user"
git push origin $branch <EOF
$username
$password
EOF
