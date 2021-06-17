#!/bin/bash
#
cd /tmp
psql -d test -c "\COPY (SELECT local_joincount(women, nn10) OVER() FROM nets_lisa WHERE ogc_fid > $RUN_START AND ogc_fid < $RUN_END) TO result.csv CSV HEADER";
tar -czf result.tar.gz result.csv
#s3cmd put /tmp/result.tar.gz s3://postgeoda/ljc$RUN_START-$RUN_END.tar.gz
