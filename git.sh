git add .
git commit -m "test"
user=$(zenity --password --username 2> /dev/null)
IFS="|" read -r username password   <<< "$user"
git push origin $branch <EOF
$username
$password
EOF

