#!/bin/bash

exec /usr/share/tomcat7/bin/catalina.sh run >>/var/log/tomcat7.log 2>&1
