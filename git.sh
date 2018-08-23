git init
git add .
git commit -m "test"
user=$(zenity --password --username 2> /dev/null)
IFS="|" read -r username password   <<< "$user";
git config user.name "$username"
git push << EOF
$username
$password
EOF
