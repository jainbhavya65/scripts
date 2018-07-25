image_name=jainbhavya65/jenkins
i=$(sudo docker images | grep -i jainbhavya65/jenkins | cut -d ' '  -f26 | wc -l )
if [ "$JOB_NAME" = "Git-copy" ];
then
git clone https://github.com/jainbhavya65/nodejs.git
sudo rsync -Parv nodejs ../../
elif [ "$JOB_NAME" = "docker-build" ];
then
i=$(expr $i + 1)
cd ../../nodejs
sudo docker build -t $image_name:$i .
elif [ "$JOB_NAME" = "docker-testing" ];
then
sudo docker run $image_name:$i /bin/cat server.js
elif [ "$JOB_NAME" = "docker-push" ];
then
sudo docker login --username=$dockeruser --password=$dockerpassword
sudo docker push $image_name:$i 
elif [ "$JOB_NAME" = "test-run" ];
then
kubectl get nodes
fi
