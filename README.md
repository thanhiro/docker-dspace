# docker-dspace

Docker container for [DSpace 5.3][3]

"DSpace is the software of choice for academic, non-profit, and commercial organizations building open digital repositories."

## Install dependencies

  - [Docker][2]

To install docker in Ubuntu 14.04 use the commands:

    $ sudo apt-get update
    $ sudo apt-get install docker.io

 To install docker in other operating systems check [docker online documentation][4]
 
## Usage

To run container use the command below:

    $ docker run -d -p 8080:8080 quantumobject/docker-dspace

### Creating an administrator user

You need to run this command from the container to create the administrator user:

    $ docker exec -it container_id create-admin

And respond (yes) to clean the database and the other question relate to create administrator account.

## Accessing the DSpace applications:

After that check with your browser at addresses:

XMLUI
 - **http://host_ip:8080/xmlui/** 
 
JSPUI
 - **http://host_ip:8080/jspui/**
 
OAI
 - **http://host_ip:8080/oai/**

## More Info

About DSpace: [www.dspace.org][1]

To help improve this container [docker-dspace][5]

For additional info about us and our projects check our site [www.quantumobject.com][6]

[1]:http://www.dspace.org
[2]:https://www.docker.com
[3]:https://wiki.duraspace.org/display/DSPACE/DSpace+Release+5.1+Status
[4]:http://docs.docker.com
[5]:https://github.com/QuantumObject/docker-dspace
[6]:http://www.quantumobject.com

## tunneling

ssh -i ~/.docker/machine/machines/default/id_rsa \
docker@$(docker-machine ip default) \
-L 9999:localhost:8080
