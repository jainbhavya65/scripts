git init
git add .
git commit -m "test"
user=$(zenity --password --username 2> /dev/null)
IFS="|" read -r username password   <<< "$user";
git push https://$username:$password@github.com/jainbhavya65/scripts.git master
