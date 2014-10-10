#!/bin/bash


#reason of this script is that dockerfile only execute one command at the time but we need sometimes at the moment we create 
#the docker image to run more that one software for expecified configuration like when you need mysql running to chnage or create
#database for the container ...

  echo "local all dspace md5" >> /etc/postgresql/9.3/main/pg_hba.conf
  useradd -m dspace
  echo "admin:admin"|passwd dspace # need to fix
  mkdir /dspace
  chown dspace /dspace
