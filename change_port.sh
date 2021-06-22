#!/bin/bash
#
sed -i "s/port = 5432/port = $NEW_PORT/" /etc/postgresql/10/main/postgresql.conf