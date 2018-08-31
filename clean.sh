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
cd /usr/local/src
rm -rf crmpromote
rm -rf $homedir/Desktop/Crm.desktop
sed -i "9 s|rm -rf /tmp/crm_done_task| |" /etc/init/shutdown.conf
fi
