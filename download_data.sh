#!/bin/bash
#
cd /tmp
#s3cmd get s3://postgeoda/nets_lisa.zip /tmp/nets_lisa.zip
wget https://postgeoda.s3.us-east-2.amazonaws.com/nets_lisa.zip
unzip nets_lisa.zip
