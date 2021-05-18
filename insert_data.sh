#!/bin/bash
#set -e

while true;
do
date=`date +'%Y%m%d%H%M%S'`
MYSQL1_USER="retl"
MYSQL1_PASSWD=""
MYSQL1_HOST=""
MYSQL1_PORT="3306"
MYSQL1_TABLE="otter_test.example"

MYSQL2_USER="retl"
MYSQL2_PASSWD=""
MYSQL2_HOST=""
MYSQL2_PORT="60118"
MYSQL2_TABLE="otter_test.example"
sleep 10

#echo ${MYSQL1_USER} ${MYSQL1_PASSWD} ${MYSQL1_HOST} ${MYSQL1_PORT}
timeout 3 mysql -u${MYSQL1_USER} -p${MYSQL1_PASSWD} -h${MYSQL1_HOST} -P${MYSQL1_PORT} -e "select count(*) from ${MYSQL1_TABLE};"

if [ $? = 0 ]; then
    echo insert into MYSQL1
    mysql -u${MYSQL1_USER} -p${MYSQL1_PASSWD} -h${MYSQL1_HOST} -P${MYSQL1_PORT} -e "insert into ${MYSQL1_TABLE}(id,name) values(null,'${date}');"
else
    echo insert into MYSQL2
    mysql -u${MYSQL2_USER} -p${MYSQL2_PASSWD} -h${MYSQL2_HOST} -P${MYSQL2_PORT} -e "insert into ${MYSQL2_TABLE}(id,name) values(null,'${date}');"
fi

done
