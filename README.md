docker-dspace
=============

docker container for DSpace v.4.2

To run container by :

docker run -d -p 8080:8080 quantumobject/docker-dspace

You need to run this command from the container to create the administrator user ... for that you need to use command :

docker-bash container_id         

/dspace/bin/dspace create-administrator 


after that check with your brownser to http://ip:8080/xmlui/


note: docker-bash is available by installing quantumobject/tools  from https://github.com/QuantumObject/docker-tools
