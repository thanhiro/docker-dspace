#!/bin/bash


#reason of this script is that dockerfile only execute one command at the time but we need sometimes at the moment we create 
#the docker image to run more that one software for expecified configuration like when you need mysql running to chnage or create
#database for the container ...
  
  # need to install maven3
  wget http://ppa.launchpad.net/natecarlson/maven3/ubuntu/pool/main/m/maven3/maven3_3.2.1-0~ppa1_all.deb
  dpkg -i  maven3_3.2.1-0~ppa1_all.deb
  ln -s /usr/share/maven3/bin/mvn /usr/bin/mvn
  rm maven3_3.2.1-0~ppa1_all.deb
  
  echo "mark 1 ..................."
  
  # created user
  useradd -m dspace
  echo "dspace:admin"|chpasswd
  mkdir /dspace
  chown dspace /dspace

  #conf tomcat7 for dspace
  a=$(cat /etc/tomcat7/server.xml | grep -n "</Host>"| cut -d : -f 1 )
  sed -i "$((a-1))r /tmp/dspace_tomcat7.conf" /etc/tomcat7/server.xml
  
   echo "mark 2 ..................."
  
  mkdir /build
        chmod -R 770 /build
        cd /build
        wget http://sourceforge.net/projects/dspace/files/DSpace%20Stable/4.2/dspace-4.2-src-release.tar.gz
        tar -zxf dspace-4.2-src-release.tar.gz
        rm dspace-4.2-src-release.tar.gz
        
        echo "mark 3 ..................."
        
        cd /build/dspace-4.2-src-release
        mvn -U package
        
        echo "mark 4 ................."
        
    #conf database before build and installation of dspace
        POSTGRESQL_BIN=/usr/lib/postgresql/9.3/bin/postgres
        POSTGRESQL_CONFIG_FILE=/etc/postgresql/9.3/main/postgresql.conf
        
        /sbin/setuser postgres $POSTGRESQL_BIN --single \
                --config-file=$POSTGRESQL_CONFIG_FILE \
              <<< "UPDATE pg_database SET encoding = pg_char_to_encoding('UTF8') WHERE datname = 'template1'" &>/dev/null

        /sbin/setuser postgres $POSTGRESQL_BIN --single \
                --config-file=$POSTGRESQL_CONFIG_FILE \
                  <<< "CREATE USER dspace WITH SUPERUSER;" &>/dev/null
        /sbin/setuser postgres $POSTGRESQL_BIN --single \
                --config-file=$POSTGRESQL_CONFIG_FILE \
                <<< "ALTER USER dspace WITH PASSWORD 'dspace';" &>/dev/null
                
        echo "local all dspace md5" >> /etc/postgresql/9.3/main/pg_hba.conf
        
         echo "mark 5 ..................."
        
       /sbin/setuser postgres /usr/lib/postgresql/9.3/bin/postgres -D  /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf >>/var/log/postgresd.log 2>&1 &

        sleep 10s
        
          echo "mark 5.5 ..................."
        
        /sbin/setuser dspace createdb -U dspace -E UNICODE dspace 
        # build dspace and install
         
        echo "mark 6 ..................."
         
        
        
        cd /build/dspace-4.2-src-release/dspace/target/dspace-4.2-build
      
        ant fresh_install
        chown tomcat7:tomcat7 /dspace -R
        #this need some help for no interractive
        # /dspace/bin/dspace create-administrator 
     
        killall postgres
        sleep 10s

  apt-get clean
  #rm -rf /build   # for checking status ...
  rm -rf /tmp/* /var/tmp/*
  rm -rf /var/lib/apt/lists/*
  
