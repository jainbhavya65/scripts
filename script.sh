#!/bin/bash
if [ "$JOB_NAME" = "Git-copy" ];
then
mkdir ../../project1
mv project1-script.sh ../../project1/
bash project1-script.sh
fi
