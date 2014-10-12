#!/bin/bash


#reason of this script is that dockerfile only execute one command at the time but we need sometimes at the moment we create 
#the docker image to run more that one software for expecified configuration like when you need mysql running to chnage or create
#database for the container ...
  
  # need to install maven3
  wget http://ppa.launchpad.net/natecarlson/maven3/ubuntu/pool/main/m/maven3/maven3_3.2.1-0~ppa1_all.deb
  dpkg -i  maven3_3.2.1-0~ppa1_all.deb
  ln -s /usr/share/maven3/bin/mvn /usr/bin/mvn
  
  # created user
  useradd -m dspace
  echo "dspace:admin"|chpasswd
  mkdir /dspace
  chown dspace /dspace

  #conf tomcat7 for dspace
  a=$(cat /etc/tomcat7/server.xml | grep -n "</Host>"| cut -d : -f 1 )
  sed -i "$((a-1))r /tmp/dspace_tomcat7.conf" /etc/tomcat7/server.xml

  apt-get clean
  rm -rf /tmp/* /var/tmp/*
  rm -rf /var/lib/apt/lists/*
  
