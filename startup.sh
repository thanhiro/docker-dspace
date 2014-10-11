#!/bin/bash


set -e

if [ -f /etc/configured ]; then
        echo 'already configured'
else
      #code that need to run only one time ....
        
         POSTGRESQL_BIN=/usr/lib/postgresql/9.3/bin/postgres
        POSTGRESQL_CONFIG_FILE=/etc/postgresql/9.3/main/postgresql.conf

      # /sbin/setuser postgres $POSTGRESQL_BIN --single \
      #          --config-file=$POSTGRESQL_CONFIG_FILE \
      #        <<< "UPDATE pg_database SET encoding = pg_char_to_encoding('UTF8') WHERE datname = 'template1'" &>/dev/null
       
        /sbin/setuser postgres $POSTGRESQL_BIN --single \
                --config-file=$POSTGRESQL_CONFIG_FILE \
                  <<< "CREATE USER dspace WITH SUPERUSER;" &>/dev/null
        /sbin/setuser postgres $POSTGRESQL_BIN --single \
                --config-file=$POSTGRESQL_CONFIG_FILE \
                <<< "ALTER USER dspace WITH PASSWORD 'dspace';" &>/dev/null
        #maybe different conf for this container ... 
        #sed -i 's/ssl = true/ssl = false/' /etc/postgresql/9.3/main/postgresql.conf
        
        #needed for fix problem with ubuntu and cron
        update-locale 
        date > /etc/configured
fi
