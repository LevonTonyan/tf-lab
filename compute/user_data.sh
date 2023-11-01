#!/bin/bash -xe

exec > >(tee /var/log/cloud-init-output.log|logger -t user-data -s 2>/dev/console) 2>&1

cd /home/ec2-user

COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid |tr '[:upper:]' '[:lower:]')
BUCKET_NAME=REPLACE_ME

COMPUTE_INSTANCE_ID=`curl "http://169.254.169.254/latest/meta-data/instance-id"`

echo This message was generated on instance "${COMPUTE_INSTANCE_ID}" with the following UUID "${COMPUTE_MACHINE_UUID}" > "${COMPUTE_INSTANCE_ID}".txt

aws s3 cp "${COMPUTE_INSTANCE_ID}.txt" s3://"epam-tf-lab-${BUCKET_NAME}"/

