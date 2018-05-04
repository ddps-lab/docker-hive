#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_PREFIX/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

service ssh start
$HADOOP_PREFIX/sbin/start-dfs.sh
$HADOOP_PREFIX/sbin/start-yarn.sh

$HADOOP_PREFIX/bin/hadoop fs -mkdir       /tmp
$HADOOP_PREFIX/bin/hadoop fs -mkdir -p    /user/hive/warehouse
$HADOOP_PREFIX/bin/hadoop fs -chmod g+w   /tmp
$HADOOP_PREFIX/bin/hadoop fs -chmod g+w   /user/hive/warehouse


#mysql
service mysql start
cd $HIVE_HOME/scripts/metastore/upgrade/mysql
mysql -u root -phive <<QUERY
CREATE DATABASE metastore;
USE metastore;
SOURCE hive-schema-2.3.0.mysql.sql;
CREATE USER 'hiveuser'@'%' IDENTIFIED BY 'hivepassword';
GRANT all on *.* to 'hiveuser'@localhost identified by 'hivepassword';
flush privileges;
QUERY
cd /
echo "initializing metastore"
$HIVE_HOME/bin/schematool -dbType mysql -initSchema

CMD=${1:-"exit 0"}
if [[ "$CMD" == "-d" ]];
then
	service sshd stop
	/usr/sbin/sshd -D -d
else
	/bin/bash -c "$*"
fi
