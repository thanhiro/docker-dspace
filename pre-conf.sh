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
 
   sed -i '$ar /tmp/dspace_tomcat7.conf' /etc/tomcat7/server.xml
   
