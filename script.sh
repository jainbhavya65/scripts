image_name=jainbhavya65/jenkins
i=$(sudo docker images | grep -i jainbhavya65/jenkins | cut -d ' '  -f26 | wc -l )
i=$(expr $i + 1)
if [ "$JOB_NAME" = "Git-copy" ];
then
git clone https://github.com/jainbhavya65/nodejs.git
rsync -Parv nodejs ../../
elif [ "$JOB_NAME" = "docker-build" ];
then
cd ../../nodejs
sudo docker build -t $image_name:$i .
fi
