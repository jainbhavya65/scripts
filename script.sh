#!/bin/bash
if [ "$JOB_NAME" = "iface-crm-api-1-github-clone-03-aug-2018" ];
then
mkdir ../iface-crm-api
chmod -R 777 ../iface-crm-api
mv iface-crm-api.sh ../iface-crm-api/
cd ../iface-crm-api
bash iface-crm-api.sh
rm -rf *
fi
