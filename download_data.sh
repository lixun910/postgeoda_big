#!/bin/bash
#
cd ~
mkdir .aws
cd .aws
echo "[default]" >> credentials
echo "aws_access_key_id=$AWS_ACCESS_KEY" >> credentials
echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> credentials
echo "[default]" >> config
echo "region=$AWS_REGION" >> config
echo "output=json">> config

#aws s3 cp s3://postgeoda/nets_lisa.zip /tmp/nets_lisa.zip
cd /tmp
unzip nets_lisa.zip
