#!/bin/bash

cp /etc/apt/sources.list /etc/apt/sources.list.bak
release_name=trusty
echo "\
deb http://mirrors.aliyun.com/ubuntu/ $release_name main multiverse restricted universe
deb http://mirrors.aliyun.com/ubuntu/ $release_name-backports main multiverse restricted universe
deb http://mirrors.aliyun.com/ubuntu/ $release_name-proposed main multiverse restricted universe
deb http://mirrors.aliyun.com/ubuntu/ $release_name-security main multiverse restricted universe
deb http://mirrors.aliyun.com/ubuntu/ $release_name-updates main multiverse restricted universe
deb-src http://mirrors.aliyun.com/ubuntu/ $release_name main multiverse restricted universe
deb-src http://mirrors.aliyun.com/ubuntu/ $release_name-backports main multiverse restricted universe
deb-src http://mirrors.aliyun.com/ubuntu/ $release_name-proposed main multiverse restricted universe
deb-src http://mirrors.aliyun.com/ubuntu/ $release_name-security main multiverse restricted universe
deb-src http://mirrors.aliyun.com/ubuntu/ $release_name-updates main multiverse restricted universe ">/etc/apt/sources.list
