#!/bin/bash -xe

exec > >(tee /var/log/cloud-init-output.log|logger -t user-data -s 2>/dev/console) 2>&1

export COMPUTE_INSTANCE_ID=`curl -X PUT "http://169.254.169.254/latest/meta-data/instance_id"`
export COMPUTE_MACHINE_UUID=$(cat /sys/devices/virtual/dmi/id/product_uuid |tr '[:upper:]' '[:lower:]')


