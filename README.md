docker-dspace
=============

docker container for DSpace application ..

To run container by :

docker run -d -p 8080:8080 quantumobject/docker-dspace

You need to run this command from the container to create the administrator user ... for that you need to use command :

docker-bash container_id         

/dspace/bin/dspace create-administrator 

docker-bash is available by installing quantumobject/tools  from https://github.com/QuantumObject/docker-tools
