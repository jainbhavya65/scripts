#!/bin/bash
echo "  ____    _   _   _   _        _      ____      ____     ___     ___    _____ 
 |  _ \  | | | | | \ | |      / \    / ___|    |  _ \   / _ \   / _ \  |_   _|
 | |_) | | | | | |  \| |     / _ \   \___ \    | |_) | | | | | | | | |   | |  
 |  _ <  | |_| | | |\  |    / ___ \   ___) |   |  _ <  | |_| | | |_| |   | |  
 |_| \_\  \___/  |_| \_|   /_/   \_\ |____/    |_| \_\  \___/   \___/    |_|  
                                                                              "
user=$(who|awk '{print $1}') 
cd /usr/local/src
git clone https://github.com/jainbhavya65/test.git
cd test
tar -xvf crmpromote.tar
setfacl -m u:$user:r-x crmpromote
chown -R $user:$user crmpromote
cd crmpromote
cp .crmpromote.sh /home/$user/
chown -R $user:$user /home/$user/.crmpromote.sh
echo "source ~/.crmpromote.sh" >> /home/$user/.bashrc
cp Crm.desktop /home/$user/Desktop
chown -R $user:$user /home/$user/Desktop/Crm.desktop
sed -i "9i rm -rf /tmp/done_task" shutdown.conf
