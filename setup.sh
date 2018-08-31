#!/bin/bash
if [ $(whoami) != "root" ]
then
echo " ____  __    ____   __   ____  ____        ____  _  _  __ _         __   ____        ____   __    __   ____ 
(  _ \(  )  (  __) / _\ / ___)(  __)      (  _ \/ )( \(  ( \       / _\ / ___)      (  _ \ /  \  /  \ (_  _)
 ) __// (_/\ ) _) /    \\___ \ ) _)         )   /) \/ (/    /      /    \\___ \        )   /(  O )(  O )  )(  
(__)  \____/(____)\_/\_/(____/(____)      (__\_)\____/\_)__)      \_/\_/(____/      (__\_) \__/  \__/  (__) "
else
user=$(who|awk '{print $1}') 
homedir=$(cat /etc/passwd | grep -i $user | cut -d ":" -f6)
user1=$(echo $homedir | awk -F/ "{print $3}")
group=$(cat /etc/group | grep -i $user1 | awk -F: {"print $1"})
cd /usr/local/src
git clone https://github.com/jainbhavya65/test.git
cd test
tar -xvf crmpromote.tar
setfacl -m u:$user:r-x crmpromote
chown -R $user:$group crmpromote
cd crmpromote
cp .crmpromote.sh $homedir
chown -R $user:$group $homedir/.crmpromote.sh
echo "source ~/.crmpromote.sh" >> $homedir/.bashrc
cp Crm.desktop $homedir/Desktop
chown -R $user:$group $homedir/Desktop/Crm.desktop
sed -i "9i rm -rf /tmp/crm_done_task" /etc/init/shutdown.conf
fi
