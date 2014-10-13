#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        echo 'already configured'
else
        #code that need to run only one time ....
        
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
        
       /sbin/setuser postgres /usr/lib/postgresql/9.3/bin/postgres  /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf >>/var/log/postgresd.log 2>&1 &

        sleep 10s
        
        /sbin/setuser dspace createdb -U dspace -E UNICODE dspace 
        # build dspace and install
        
        cd /build/dspace-4.2-src-release/dspace/target/dspace-4.1-build
        #need database running for this command to work ...
        # /sbin/setuser postgres /usr/lib/postgresql/9.3/bin/postgres -D /var/lib/postgresql/9.3/main -c config_file=/etc/postgresql/9.3/main/postgresql.conf >>/var/log/postgresd.log 2>&1
        ant fresh_install
        chown tomcat7:tomcat7 /dspace -R
         #this need some help for no interractive
         /dspace/bin/dspace create-administrator 
         #stop database ... after install ... 
        
        killall postgres
        sleep 10s
        
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi
