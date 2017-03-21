#Using official python runtime base image
FROM hub.c.163.com/library/ubuntu:14.04
#FROM centos:latest
MAINTAINER ShiWenQiang <shiwenqiang@pioneerdata.cn>

ENV FALCON_ROOT_PATH /home/work/open-falcon

RUN mkdir -p $FALCON_ROOT_PATH

ADD ./open-falcon-latest.tar.gz $FALCON_ROOT_PATH

ADD ./config-start.sh $FALCON_ROOT_PATH
ADD ./install-alideb.sh $FALCON_ROOT_PATH

RUN chmod a+x $FALCON_ROOT_PATH/*.sh

RUN cd $FALCON_ROOT_PATH && mkdir agent \
                               && mkdir aggregator \
                               && mkdir alarm \
                               && mkdir dashboard \
                               && mkdir fe \
                               && mkdir gateway \
                               && mkdir graph \
                               && mkdir hbs \
                               && mkdir judge \
                               && mkdir links \
                               && mkdir nodata \
                               && mkdir portal \
                               && mkdir query \
                               && mkdir sender \
                               && mkdir task \
                               && mkdir transfer

RUN cd $FALCON_ROOT_PATH && tar -zxvf falcon-agent-5.1.0.tar.gz -C agent \
                               && tar -zxvf falcon-aggregator-0.0.4.tar.gz -C aggregator \
                               && tar -zxvf falcon-alarm-2.0.2.tar.gz -C alarm \
                               && tar -zxvf falcon-dashboard-35dbee7.tar.gz -C dashboard \
                               && tar -zxvf falcon-fe-0.0.5.tar.gz -C fe \
                               && tar -zxvf falcon-gateway-0.0.11.tar.gz -C gateway \
                               && tar -zxvf falcon-graph-0.5.6.tar.gz -C graph \
                               && tar -zxvf falcon-hbs-1.1.0.tar.gz -C hbs \
                               && tar -zxvf falcon-judge-2.0.2.tar.gz -C judge \
                               && tar -zxvf falcon-links-bc932dd.tar.gz -C links \
                               && tar -zxvf falcon-nodata-0.0.8.tar.gz -C nodata \
                               && tar -zxvf falcon-portal-1c8d04d.tar.gz -C portal \
                               && tar -zxvf falcon-query-1.4.3.tar.gz -C query \
                               && tar -zxvf falcon-sender-0.0.0.tar.gz -C sender \
                               && tar -zxvf falcon-task-0.0.10.tar.gz -C task \
                               && tar -zxvf falcon-transfer-0.0.17.tar.gz -C transfer \
                               && rm -rf *.tar.gz

ADD ./portal/web $FALCON_ROOT_PATH/portal/web

RUN rename  '.example' ''  $FALCON_ROOT_PATH/*/*

#install ali deb
RUN sh $FALCON_ROOT_PATH/install-alideb.sh

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y redis-server \
                               && apt-get install -y mysql-server mysql-client \
                               && apt-get install -y libmysqlclient-dev libmysqld-dev \
                               && apt-get install -y libxml2-dev libxslt1-dev python-dev \
                               && apt-get install -y python-virtualenv \
                               && apt-get install -y git

RUN service mysql start && git clone https://github.com/open-falcon/scripts.git \
                        && cd scripts \
                        && mysql -h localhost -u root < db_schema/graph-db-schema.sql \
                        && mysql -h localhost -u root < db_schema/dashboard-db-schema.sql \
                        && mysql -h localhost -u root < db_schema/portal-db-schema.sql \
                        && mysql -h localhost -u root < db_schema/links-db-schema.sql \
                        && mysql -h localhost -u root < db_schema/uic-db-schema.sql

#install python pip_requirements
RUN cd $FALCON_ROOT_PATH/dashboard/ && virtualenv ./env \
                                     && ./env/bin/pip install -r pip_requirements.txt  -i http://pypi.douban.com/simple \
                                     && cd $FALCON_ROOT_PATH/portal/ \
                                     && virtualenv ./env \
                                     && ./env/bin/pip install -r pip_requirements.txt  -i http://pypi.douban.com/simple

WORKDIR $FALCON_ROOT_PATH

EXPOSE 6060 6030 9966 6031 8433 1234 6070 6071 9912 5050 5090 8081 3306

CMD $FALCON_ROOT_PATH/config-start.sh && tail -f /home/work/open-falcon/portal/var/app.log
