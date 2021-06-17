#!/bin/bash
#
cd ~
mkdir .aws
cd .aws
rm credentials
echo "[default]" >> credentials
echo "aws_access_key_id=$AWS_ACCESS_KEY" >> credentials
echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> credentials
rm config
echo "[default]" >> config
echo "region=$AWS_REGION" >> config
echo "output=json">> config
cd /tmp
psql -d test -c "\COPY (SELECT local_joincount(women, nn10) OVER() FROM nets_lisa WHERE ogc_fid > $RUN_START AND ogc_fid < $RUN_END) TO result.csv CSV HEADER";
tar -czf result.tar.gz result.csv
aws s3 cp /tmp/result.tar.gz s3://postgeoda/ljc$RUN_START-$RUN_END.tar.gz
