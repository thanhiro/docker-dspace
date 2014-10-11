#!/bin/bash
ADMIN_USER=${ADMIN_USER:-admin}
ADMIN_PASS=${ADMIN_PASS:-tomcat}
MAX_UPLOAD_SIZE=${MAX_UPLOAD_SIZE:-52428800}

 cat << EOF > /usr/share/tomcat7/conf/tomcat-users.xml
 <?xml version='1.0' encoding='utf-8'?>
 <tomcat-users>
 <user username="${ADMIN_USER}" password="${ADMIN_PASS}" roles="admin-gui,manager-gui"/>
</tomcat-users>
EOF

 if [ -f "/usr/share/tomcat7/webapps/manager/WEB-INF/web.xml" ]
         then
        sed -i "s#.*max-file-size.*#\t<max-file-size>${MAX_UPLOAD_SIZE}</max-file-size>#g" /usr/share/tomcat7/webapps/manager/WEB-INF/web.xml
        sed -i "s#.*max-request-size.*#\t<max-request-size>${MAX_UPLOAD_SIZE}</max-request-size>#g" /usr/share/tomcat7/webapps/manager/WEB-INF/web.xml
 fi

exec /usr/share/tomcat7/bin/catalina.sh run >>/var/log/tomcat7.log 2>&1
