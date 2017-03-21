#!/bin/bash


#config open-falcon
if [ $HOST_IP ];then
    echo "config sender......"
    sed -i 's/11.11.11.11/'$HOST_IP'/g' $FALCON_ROOT_PATH/sender/cfg.json
    echo "config alarm......"
    sed -i 's/falcon.example.com/'$HOST_IP':5050/g' $FALCON_ROOT_PATH/alarm/cfg.json
    sed -i 's/uic.example.com/'$HOST_IP':1234/g' $FALCON_ROOT_PATH/alarm/cfg.json
    echo "config hbs......"
    echo "config fe......"
    sed -i 's/11.11.11.11:7070/'$HOST_IP':8081/g' $FALCON_ROOT_PATH/fe/cfg.json
    sed -i 's/11.11.11.11/'$HOST_IP'/g' $FALCON_ROOT_PATH/fe/cfg.json
    echo "config graph......"
    echo "config portal......"
    sed -i 's/127.0.0.1:8080/127.0.0.1:1234/g' $FALCON_ROOT_PATH/portal/frame/config.py
    sed -i 's/11.11.11.11:8080/'$HOST_IP':1234/g' $FALCON_ROOT_PATH/portal/frame/config.py
fi

echo "config mysql......"
sed -i 's/bind-address/#bind-address/g' /etc/mysql/my.cnf

#start redis and mysql
service redis-server start
service mysql start

echo "
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;
" > ./grant.sql;
mysql -uroot <./grant.sql

echo "
INSERT INTO uic.user(id, name, passwd, cnname, email, phone, im, qq, role, creator, created) VALUES ('1', 'root', '202cb962ac59075b964b07152d234b70', '', '', '', '', '', '2', '0', '2016-12-15 18:11:32');
" > ./init_user.sql;
mysql -uroot <./init_user.sql


#start open-falcon-component
$FALCON_ROOT_PATH/judge/control start
$FALCON_ROOT_PATH/query/control start
$FALCON_ROOT_PATH/sender/control start
$FALCON_ROOT_PATH/alarm/control start
$FALCON_ROOT_PATH/hbs/control start
$FALCON_ROOT_PATH/fe/control start
$FALCON_ROOT_PATH/transfer/control start
$FALCON_ROOT_PATH/graph/control start
$FALCON_ROOT_PATH/dashboard/control start
$FALCON_ROOT_PATH/portal/control start