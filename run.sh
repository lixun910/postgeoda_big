#!/bin/bash
#
cd ~
mkdir -p .aws
cd .aws
rm -f credentials
echo "[default]" >> credentials
echo "aws_access_key_id=$AWS_ACCESS_KEY" >> credentials
echo "aws_secret_access_key=$AWS_SECRET_ACCESS_KEY" >> credentials
rm -f config 
echo "[default]" >> config
echo "region=$AWS_REGION" >> config
echo "output=json">> config
cd /tmp
psql -d test -c "\COPY (SELECT ogc_fid, local_joincount_fast(women, nn10, ARRAY(SELECT women FROM nets_lisa order by ogc_fid)) OVER() FROM nets_lisa WHERE ogc_fid >= $RUN_START AND ogc_fid <= $RUN_END) TO result.csv CSV HEADER";
tar -czf result.tar.gz result.csv
aws s3 cp /tmp/result.tar.gz s3://postgeoda/ljc$RUN_START-$RUN_END.tar.gz
