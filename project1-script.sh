image_name=itsolvs/iface-crm-app
if [ "$JOB_NAME" = "Git-copy" ];
then
git clone https://github.com/jainbhavya65/nodejs.git
elif [ "$JOB_NAME" = "docker-build" ];
then
cd nodejs
i=$(cat app.yaml | grep -i iface-crm-app | awk -F: '/- image: / {print $3}')
echo $i
sudo docker build -t $image_name:$i .
elif [ "$JOB_NAME" = "docker-testing" ];
then
sudo docker run $image_name:$i /bin/cat server.js
elif [ "$JOB_NAME" = "docker-push" ];
then
sudo docker login --username=$dockeruser --password=$dockerpassword
sudo docker push $image_name:$i 
fi
