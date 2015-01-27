docker-dspace
=============

docker container for DSpace v.5.0

To run container by :

docker run -d -p 8080:8080 quantumobject/docker-dspace

You need to run this command from the container to create the administrator user:

docker exec -it container_id  /bin/bash /dspace/bin/dspace create-administrator 


after that check with your brownser at http://host_ip:8080/xmlui/  and http://host_ip:8080/jspui/

more info about DSpace:

[www.dspace.org](www.dspace.org)
