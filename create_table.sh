#!/bin/bash
#
cd /tmp
psql -d test -c "CREATE TABLE nets_lisa (ogc_fid integer, women integer, nn10 bytea, PRIMARY KEY (ogc_fid))";
psql -d test -c "\COPY nets_lisa(ogc_fid, women, nn10) FROM nets_lisa.csv CSV HEADER";
