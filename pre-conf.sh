#!/bin/bash


#reason of this script is that dockerfile only execute one command at the time but we need sometimes at the moment we create 
#the docker image to run more that one software for expecified configuration like when you need mysql running to chnage or create
#database for the container ...

  echo "local all dspace md5" >> /etc/postgresql/9.3/main/pg_hba.conf
  useradd -m dspace
  echo "dspace:admin"|chpasswd
  mkdir /dspace
  chown dspace /dspace
  
  a=$(cat /etc/tomcat7/server.xml | grep -n "</Host>"| cut -d : -f 1 )
  sed -i "$((a-1))r /tmp/dspace_tomcat7.conf" /etc/tomcat7/server.xml
  
  mkdir /build
  chmod -R 770 /build
  cd /build
  wget http://sourceforge.net/projects/dspace/files/DSpace%20Stable/4.2/dspace-4.2-src-release.tar.gz
  tar -zxf dspace-4.2-src-release.tar.gz
  rm dspace-4.2-src-release.tar.gz
  cd /build/dspace-4.2-src-release/dspace
  mvn -U package
  cd dspace/target/dspace-4.1-build
  ant fresh_install
  chown tomcat7:tomcat7 /dspace -R
  #this need some help for no interractive
  /dspace/bin/dspace create-administrator 
