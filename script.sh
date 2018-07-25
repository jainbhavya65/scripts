#!/bin/bash
if [ "$JOB_NAME" = "Git-copy" ];
then
mkdir ../../project1
mv scripts/project1-script.sh ../../project1/
cd ../../project1
bash project1-script.sh
rm -rf *
fi
