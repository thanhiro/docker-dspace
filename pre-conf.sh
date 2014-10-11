#!/bin/bash


#reason of this script is that dockerfile only execute one command at the time but we need sometimes at the moment we create 
#the docker image to run more that one software for expecified configuration like when you need mysql running to chnage or create
#database for the container ...
  
  # need to install maven3
  wget http://ppa.launchpad.net/natecarlson/maven3/ubuntu/pool/main/m/maven3/maven3_3.2.1-0~ppa1_all.deb
  dpkg -i  maven3_3.2.1-0~ppa1_all.deb
  ln -s /usr/share/maven3/bin/mvn /usr/bin/mvn
  
  
  
  useradd -m dspace
  echo "dspace:admin"|chpasswd
  mkdir /dspace
  chown dspace /dspace
  
  
  POSTGRESQL_BIN=/usr/lib/postgresql/9.3/bin/postgres
  POSTGRESQL_CONFIG_FILE=/etc/postgresql/9.3/main/postgresql.conf

  /sbin/setuser postgres $POSTGRESQL_BIN --single \
                --config-file=$POSTGRESQL_CONFIG_FILE \
                  <<< "CREATE USER dspace WITH SUPERUSER;" &>/dev/null
  /sbin/setuser postgres $POSTGRESQL_BIN --single \
                --config-file=$POSTGRESQL_CONFIG_FILE \
                <<< "ALTER USER dspace WITH PASSWORD 'dspace';" &>/dev/null
                
  echo "local all dspace md5" >> /etc/postgresql/9.3/main/pg_hba.conf
  /sbin/setuser dspace createdb -U dspace -E UNICODE dspace 
  
  a=$(cat /etc/tomcat7/server.xml | grep -n "</Host>"| cut -d : -f 1 )
  sed -i "$((a-1))r /tmp/dspace_tomcat7.conf" /etc/tomcat7/server.xml
  
  mkdir /build
  chmod -R 770 /build
  cd /build
  wget http://sourceforge.net/projects/dspace/files/DSpace%20Stable/4.2/dspace-4.2-src-release.tar.gz
  tar -zxf dspace-4.2-src-release.tar.gz
  rm dspace-4.2-src-release.tar.gz
  cd /build/dspace-4.2-src-release
  mvn -U package
  cd dspace/target/dspace-4.1-build
  ant fresh_install
  chown tomcat7:tomcat7 /dspace -R
  #this need some help for no interractive
  /dspace/bin/dspace create-administrator 
