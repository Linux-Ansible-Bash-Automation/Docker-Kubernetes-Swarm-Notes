Section 4: Creating and using containers like a boss
============================================================================================================================

Session 17: Check our docker install and config
------------------------------------------------------------------------------------------------------------------------

# sudo docker version
    {Check your versions and that docker is working

# sudo docker info
    {shows most configuration values for the engine

# sudo docker
    {all commands in docker

-------------------------------------------------
Docker Command Format:

new "Management Commands" format":
new: docker <command> <sub-command> [options]
old way: docker <command> [options]
------------------------------------------------


Session 18: Starting a Nginx web server
---------------------------------------------------------------------------------------------------------------------------------
This Lecture:

* image vs. container
* run/stop/remove containers
* Check container logs and processes

* image vs. container
- An image is the application we want to run
- A container is an instance of that image running as a process
- You can have many containers off the same image 
- In this lecture our image will be the Nginx web browser 
- Docker's default image "registry" is called Docker Hub (hub.docker.com)

# docker container run --publish 80:80 nginx

1. Downloaded image 'nginx' from docker hub
2. Started a new container from that image
3. Opened port 80 onthe host IP
4. Routes that traffic to the container IP, port 80
Note: If port 80 is using by another container you can use different port like 8080:80 or 8888:80

# docker container run --publish 80:80 --detach nginx
    {detach tells docker to run it in the background

# docker container ls 
[OR]
# docker ps (old way)

# docker container stop <container-id> 52ad (or) 52ad9f6f44e2
[OR]
# docker stop (old way)

# docker container ls -a
    {we can see some randome names for containers

# docker container run --publish 80:80 --detach --name webhost nginx

# docker container logs webhost

# docker container top
    {top let us know the processes that are running on a specific container

# docker container top webhost

# docker container --help

[root@sandy007.docker Docker-mastery]$ docker container ls -a
CONTAINER ID   IMAGE     COMMAND                  CREATED          STATUS                      PORTS                                 NAMES
aeab160589fa   nginx     "/docker-entrypoint.…"   5 minutes ago    Up 5 minutes                0.0.0.0:80->80/tcp, [::]:80->80/tcp   webhost
52ad9f6f44e2   nginx     "/docker-entrypoint.…"   22 minutes ago   Exited (0) 17 minutes ago                                         hungry_chandrasekhar
e3ef30de5b25   nginx     "/docker-entrypoint.…"   28 minutes ago   Exited (0) 22 minutes ago                                         magical_sanderson

[root@sandy007.docker Docker-mastery]$ docker container rm aea 52a e3e
52a
e3e
Error response from daemon: cannot remove container "aea": container is running: stop the container before removing or force remove

Note: here 52a e3e were removed coz they are not running and aea is still running so docker won't remove it

# docker container rm -f aea
    {it will remove forecefully even the conatiner running



Session 19: Debrief: What happens when we run a container
----------------------------------------------------------------------------------------------------------------------------------

What happens in 'docker container run'
1. Looks for that image locally in image cache, doesn't find anything
2. Then looks in remote image repository (defaults to docker hub)
3. Downloads the latest version (nginx: latest by default)
4. Creates new container based on that image and prepares to start
5. Gives it a virtual ip on a private network inside docker engine
6. Opens up port 80 an host and forwards to port 80 in container 
7. Starts container by using the CMD (command) in the image Dockerfile

# docker container run --publish 8080:80 --detach --name webhost -d nginx:1.11 nginx -T 
Above command changes:
- change host listening port
- change version of image
- nginx -T : change command to run 



Session 20: Container VS. VM: It's Just a Process
-------------------------------------------------------------------------------------------------------------------------

containers aren't Mini-VM's
- They are just processes
- Limited to what resources they can access
- Exit when process stops

# docker run --name mongo -d mongo
# docker ps
# docker top mongo
# ps aux | grep mongo


Session 21: Windows Containers: should you consider them?
-------------------------------------------------------------------------------------------------------------------------

Session 22: Assignment: Manage multiple containers
-------------------------------------------------------------------------------------------------------------------------
• docs.docker.com and -- help are your friend
• Run a nginx, a mysql, and a httpd (apache) server
• Run all of them --detach (or -d), name them with --name
• nginx should listen on 80:80, httpd on 8080:80, mysql on 3306:3306
• When running mysql, use the --env option (or - e) to pass in MYSQL_RANDOM_ROOT_PASSWORD=yes
• Use "docker container logs" on mysql to find the random password it created on startup
• Clean it all up with docker container stop and docker container rm (both can accept multiple names or ID's)
• Use "docker container ls" to ensure everything is correct before and after cleanup


Session 23: Assignment Answers: Manage multiple containers
----------------------------------------------------------------------------------------------------------------------------
# docker container run --publish 80:80 --detach --name webhost-nginx
# docker container run --publish 8080:80 --detach --name webhost-https httpd
# docker container run -p 3306:3306 -d --name db -e MYSQL_RANDOM_ROOT_PASSWORD=yes mysql
# docker conatiner logs db
# docker stop ec1 7f5 9c0 
# docker ps -a
# docker image ls


Session 24: What's going on In containers: CLI process monitoring
----------------------------------------------------------------------------------------------------------
What's going on In containers:

* docker container top - process list in one container
* docker container inspect - details of one container config 
* docker container stats - performance stats for all containers

# docker container top web-browser
# docker container top sql
# docker container inspect sql
# docker container inspect web-browser

Note: inspect will show metadata about the container (start up, config, volumes, networking, etc)

# docker container stats --help
# docker container stats

Note: stats command Display a live stream of container(s) resource usage statistics


Session 25: Use MariaDB rather than MySQL   
-------------------------------------------------------------------------------------------------------------------------


Session 26: Getting a shell inside a container: No need for SSH
-------------------------------------------------------------------------------------------------------------------------   
* docker contianer run -it -start new container interactively
* docker contianer exec -it - run additonal command in existing container
* Different Linux distros in containers

# docker container run -it --name proxy-nginx nginx bash
    {if run with -it it will run interactively and give you a shell inside the container

# docker container run -it --name ubuntu ubuntu

# docker container start -ai ubuntu
    {start and attach to an existing container

# docker container exec -it ubuntu bash
    {exec will run a new command in an existing container, in this case we are running bash in the ubuntu container

# docker container exec -ai sql bash
    {attach to the sql container and run bash in it

# docker pull alpine
    {alpine is a very small linux distro, only 5mb in size

# docker image ls
    { to list all images in local cache

# docker container run -it alpine sh
    {alpine doesn't have bash, so we run sh instead


Session 27: Docker Networks: Conecepts for private and public comms in containers
-------------------------------------------------------------------------------------------------------------------------

* Review of docker container run -p
* For local dev/testing, networks usually "just work"
* Quick port check with docker container port <container>
* Learn concepts of Docker Networking
* Understand how network packets move around Docker

* Each container connected to a private virtual network "bridge"
* Each virtual network routes through NAT firewall on host IP
* All containers on a virtual network can talk to each other without -p
* Best practice is to create a new virtual network for each app:
    · network "my_web_app" for mysql and php/apache containers
    · network "my_api" for mongo and nodejs containers

* "Batteries Included, But Removable"
    · Defaults work well in many cases, but easy to swap out parts to customize it
* Make new virtual networks
* Attach containers to more then one virtual network (or none)
* Skip virtual networks and use host IP ( -- net=host)
* Use different Docker network drivers to gain new abilities
* and much more ...

# docker container run -p 80:80 --name webhost -d nginx
    {p-=--publish Remember publishing ports is always in HOST:CONTAINER format

# docker container port webhost
    {to check which ports are open on the container and where they are mapped to on the

# docker container inspect --format '{{ .NetworkSettings.IPAddress }}' webhost
    {to get the IP address of the container

# docker container inspect webhost | grep -i ipaddress
    {another way to get the IP address of the container


Session 28: FIXME: Chnage in official Nginx image removes ping
-------------------------------------------------------------------------------------------------------------------------


Session 29: Docker Networks: CLI Management of virtual networks
-------------------------------------------------------------------------------------------------------------------------
* Show networks # docker network 1s
* Inspect a network # docker network inspect
* Create a network # docker network create -- driver
* Attach a network to container # docker network connect
* Detach a network from container # docker network disconnect

# docker network ls
NETWORK ID     NAME      DRIVER    SCOPE
5ed88b13ddd4   bridge    bridge    local
d07ee02055f4   host      host      local
f5230fe6f32e   none      null      local

    {to list all networks

Note: bridge and docker0 is same
Note: host gains performance by skipping virtual networks but sacrifices security of container model
Note: Network Driver: Built in or 3rd party extensions that will give you the virtual network features

# docker network inspect bridge
    {to inspect the default bridge network

# docker network create my_app_net
    {to create a new network called my_app_net

# docker network create --help
    {to see all options for creating a network

# docker container run -d --name new_nginx --network my_app_net nginx
    {to run a new nginx container and attach it to the my_app_net network

# docker network inspect my_app_net
    {to inspect the new network and see the new container attached to it

# docker network connect my_app_net webhost
    {to connect the existing webhost container to the my_app_net network

# docker container inspect webhost
    {to see that webhost is now attached to both the default bridge network and the my_app_net network

# docker network disconnect my_app_net webhost
    {to disconnect the webhost container from the my_app_net network

# docker container inspect webhost
    {to see that webhost is now only attached to the default bridge network again

* Create your apps so frontend/backend sit on same Docker network
* Their inter-communication never leaves host
* All externally exposed ports closed by default
* You must manually expose via -p, which is better default security!
* This gets even better later with Swarm and Overlay networks


Session 30: Docker Networks: DNS and how containers find each other
-------------------------------------------------------------------------------------------------------------------------

* Understand how DNS is the key to easy inter-container comms
* See how it works by default with custom networks
* Learn how to use -- link to enable DNS on default bridge network

Docker DNS: Docker deamon has a built-in DNS server that containers use by default
DNS Default Names: Docker defaults the hostname to the container's name, but you can also set aliases

# docker container run -d --name my_nginx --network my_app_net nginx
    {to run a new nginx container and attach it to the my_app_net network

# docker exec -it my_nginx ping -c 4 new_nginx
OCI runtime exec failed: exec failed: unable to start container process: exec: "/usr/bin/ping": stat /usr/bin/ping: no such file or directory

Note: In this case install iputils-ping package inside the container to get ping command working

# docker exec -it my_nginx bash -c "apt update && apt install -y iputils-ping"
    {to install ping command inside the container

# docker exec -it my_nginx which ping
    {to check where ping command is located inside the container

# docker exec -it my_nginx ping -c 4 new_nginx
    {to ping the new_nginx container from the my_nginx container using the container name as the hostname, which is resolved by Docker's built-in DNS server

Important Note: To work DNS resolution between containers they must be on the same custom network, if they are on the default bridge network you need to use --link to enable DNS resolution between them, but it's recommended to use custom networks for better isolation and security.

* Containers shouldn't rely on IP's for inter-communication
* DNS for friendly names is built-in if you use custom networks
* You're using custom networks right?
* This gets way easier with Docker Compose in future Section


Session 31: Assignment: Using containers for CLI testing
-------------------------------------------------------------------------------------------------------------------------

* Use different Linux distro containers to check curl cli tool version
* Use two different terminal windows to start bash in both centos : 7 and ubuntu : 14.04, using -it
* Learn the docker container -- rm option so you can save cleanup
* Ensure curl is installed and on latest version for that distro
  . ubuntu: apt-get update && apt-get install curl
  · centos: yum update curl
* Check curl -- version

My Answer: I used latest images

# docker container run -it --name centos8 -d centos:centos8
   {to run a new centos container in detached mode and give it a name

# docker container exec -it centos8 bash -c "curl --version"
curl 7.61.1 (x86_64-redhat-linux-gnu) libcurl/7.61.1 OpenSSL/1.1.1g zlib/1.2.11 nghttp2/1.33.0
Release-Date: 2018-09-05
Protocols: dict file ftp ftps gopher http https imap imaps pop3 pop3s rtsp smb smbs smtp smtps telnet tftp
Features: AsynchDNS IPv6 Largefile GSS-API Kerberos SPNEGO NTLM NTLM_WB SSL libz TLS-SRP HTTP2 UnixSockets HTTPS-proxy Metalink

# docker container run -it --name ubuntu -d ubuntu:noble
    {to run a new ubuntu container in detached mode and give it a name

# docker container exec -it ubuntu bash -c "curl --version"
bash: line 1: curl: command not found

# docker container exec -it ubuntu bash -c "apt update && apt install -y curl"
    {to install curl in the ubuntu container

# docker container exec -it ubuntu bash -c "curl --version"
curl 8.5.0 (x86_64-pc-linux-gnu) libcurl/8.5.0 OpenSSL/3.0.13 zlib/1.3 brotli/1.1.0 zstd/1.5.5 libidn2/2.3.7 libpsl/0.21.2 (+libidn2/2.3.7) libssh/0.10.6/openssl/zlib nghttp2/1.59.0 librtmp/2.3 OpenLDAP/2.6.10
Release-Date: 2023-12-06, security patched: 8.5.0-2ubuntu10.8
Protocols: dict file ftp ftps gopher gophers http https imap imaps ldap ldaps mqtt pop3 pop3s rtmp rtsp scp sftp smb smbs smtp smtps telnet tftp
Features: alt-svc AsynchDNS brotli GSS-API HSTS HTTP2 HTTPS-proxy IDN IPv6 Kerberos Largefile libz NTLM PSL SPNEGO SSL threadsafe TLS-SRP UnixSockets zstd


Session 32: Assignment Answers: Using containers for CLI testing
-------------------------------------------------------------------------------------------------------------------------

Answer is pretty same as above


Session 33: Changes to Upcoming Assignment
-------------------------------------------------------------------------------------------------------------------------

Session 34: Assignment: DNS Round Robin Test
-------------------------------------------------------------------------------------------------------------------------

* Ever since Docker Engine 1.11, we can have multiple containers on a created network respond to the same DNS address
* Create a new virtual network (default bridge driver)
* Create two containers from elasticsearch: 2 image
* Research and use -network-alias search when creating them to give them an additional DNS name to respond to
* Run alpine nslookup search with -- net to see the two containers list for the same DNS name
* Run centos curl -s search: 9200 with -- net multiple times until you see both "name" fields show


Session 35: Assignment Answers: DNS Round Robin Test
--------------------------------------------------------------------------------------------------------------------------

# docker network create dude
    {to create a new network called dude

# docker container run -d --net dude --net-alias search elasticsearch:2
    {to run a new elasticsearch container and attach it to the dude network with a network alias of search

# docker container run -d --net dude --net-alias search elasticsearch:2
    {to run another elasticsearch container and attach it to the dude network with the same network alias of search

# docker container run --rm --net dude alpine nslookup search
    {to run an alpine container and use nslookup to see the two containers that are responding to the same DNS name of search

# docker container run --rm --net dude centos:7 curl -s search:9200
    {to run a centos container and use curl to see the two elasticsearch containers that are responding to the same DNS name of search on port 9200, you may need to run this command multiple times to see both "name" fields show up in the response due to DNS round robin load balancing.



Section 5: Container Images, Where to find them and How to build them
================================================================================================================================

Session 36: What's In an Image (and What isn't)
-------------------------------------------------------------------------------------------------------------------------
* All about images, the building blocks of containers
* What's in an image (and what isn't)
* Using Docker Hub registry
* Managing our local image cache
* Building our own images

What's in an image (and what isn't):

* App binaries and dependencies
* Metadata about the image data and how to run the image
* Official definition: "An Image is an ordered collection of root filesystem changes and the corresponding execution parameters for use within a container runtime."
* Not a complete OS. No kernel, kernel modules (e.g. drivers)
* Small as one file (your app binary) like a golang static binary
* Big as a Ubuntu distro with apt, and Apache, PHP, and more installed


Session 37: The Mighty Hub: Using Docker Hub Registry Images:
-------------------------------------------------------------------------------------------------------------------------
* Basics of Docker Hub (hub.docker.com)
* Find Official and other good public images
* Download images and basics of image tags


Session 38: Images and their layers: Discover the Image cache 
-------------------------------------------------------------------------------------------------------------------------
* Image layers
* union file system
* history and inspect commands
* copy on write

# docker image history nginx:latest
    {to see the layers of the nginx image and how they are built up

# docker image inspect nginx
    {to see the metadata of the nginx image, including its layers, size, and other information

Image and Their Layers - Review:
* Images are made up of file system changes and metadata
* Each layer is uniquely identified and only stored once on a host
* This saves storage space on host and transfer time on push/pull
* A container is just a single read/write layer on top of image
* docker image history and inspect commands can teach us


Session 39: Image Tagging and Pushing to Docker HUb
-------------------------------------------------------------------------------------------------------------------------
* All about image tags
* How to upload to Docker hub
* Image ID vs.Tag

# docker image tap --help
    {to see all options for tagging an image

# docker pull mysql/mysql-server
    {to pull the mysql/mysql-server image from Docker Hub

# docker image tag nginx sandeepbandela/nginx
    {to tag the nginx image with a new name sandeepbandela/nginx, which can be used to push to Docker Hub under your account

# docker login
    {to log in to Docker Hub with your credentials

# cat .docker/config.json
    {to see the Docker configuration file which contains your login credentials and other settings

# docker login -u sandeepbandela
    {to log in to Docker Hub with the username sandeepbandela, you will be prompted to enter your password

# docker image push sandeepbandela/nginx
    {to push the tagged nginx image to Docker Hub under your account, you will need to have permission to push to that repository, and it may take some time to upload depending on the size of the image and your internet connection speed

Note: so if your username is sandeepbandela you can only push to images that start with sandeepbandela/ like sandeepbandela/nginx, you cannot push to images that start with other usernames or the official library images.

# docker image push sandeepbandela/nginx:testing
    {to push the tagged nginx image with a specific tag of testing to Docker Hub under your account, you can choose any tag name you like, and it will be added to the repository on Docker Hub. This allows you to have multiple versions of the same image under different tags for better organization and version control.


Session 40: Building Images: The Dockerfile basics
-------------------------------------------------------------------------------------------------------------------------
Docs: https://docs.docker.com/reference/dockerfile/

# docker image build -f some-dockerfile
    {to build a new image from a Dockerfile, you can specify the path to the Dockerfile with the -f option, and you can also specify a tag for the new image with the -t option, for example: docker image build -f Dockerfile -t myimage:latest . This will build an image from the Dockerfile in the current directory and tag it as myimage:latest.


Session 41: Building Images: Running Docker Builds
-------------------------------------------------------------------------------------------------------------------------

[root@sandy007.docker dockerfile-sample-1]$ ls -l
total 8
-rw-r--r-- 1 root root 6510 Feb 24 12:59 Dockerfile

Note: Dockerfile is must and should be in the same directory where you are running the docker build command

#  docker image build -t sandynginx .
    {to build a new image from the Dockerfile in the current directory and tag it as sandynginx:latest, you can also specify a different tag if you want, for example: docker image build -t sandynginx:1.0 . This will build the image and tag it as sandynginx:1.0 instead of latest.

* Add port 8080 to EXPOSE stanza in Dockerfile to check how layers work

# docker image build -t sandynginx .
    {Rebuild the image after changing the Dockerfile, you will see that only the layer that changed (the one with the EXPOSE instruction) will be rebuilt, and the other layers will be cached and reused, which saves time and resources during the build process. This is one of the key benefits of using Docker's layered image system.
    
# docker image inspect sandynginx:latest
    {to check layers 


Session 42: Building Images: Estending official images 
-------------------------------------------------------------------------------------------------------------------------

# docker container run -p 80:80 --rm nginx
    {to run a new nginx container and publish port 80, with --rm to automatically remove the container when it stops

# docker image build -t nginx-with-html .
    {to build a new image from the Dockerfile in the current directory and tag it as nginx-with-html:latest, this Dockerfile should be based on the official nginx image and add some custom HTML files to be served by nginx. After building the image, you can run a container from it to see your custom HTML being served by nginx.


Session 43: Assignment: Build your own Dockerfile and Run Containers from it
-------------------------------------------------------------------------------------------------------------------------

· Dockerfiles are part process workflow and part art
· Take existing Node.js app and Dockerize it
· Make Dockerfile. Build it. Test it. Push it. (rm it). Run it.
. Expect this to be iterative. Rarely do I get it right the first time.
· Details in dockerfile-assignment-1/Dockerfile
· Use the Alpine version of the official 'node' 6.x image
· Expected result is web site at http://localhost
· Tag and push to your Docker Hub account (free)
. Romove vour image from local cache run again from Hub


Session 44: Assignment Answers: Build your own Dockerfile and Run Containers from it
-------------------------------------------------------------------------------------------------------------------------


Session 45: Using prone to keep your Docker System clean (Youtube)
-------------------------------------------------------------------------------------------------------------------------

Here's a YouTube video I made about it: https://youtu.be/_4QzP7uwtvI








Section 6: Persistent Data: Volumes, Volumes, Volumes
===========================================================================================================================

Session 46: Container Lifetime & Persistent Date
---------------------------------------------------------------------------------------------------------------------------

Section Overview

* Defining the problem of persistent data
* Key concepts with containers: immutable, ephemeral
* Learning and using Data Volumes
* Learning and using Bind Mounts
* Assignments

Container Lifetime & Persistent Data

· Containers are usually immutable and ephemeral
· "immutable infrastructure": only re-deploy containers, never change
· This is the ideal scenario, but what about databases, or unique data?
· Docker gives us features to ensure these "separation of concerns"
· This is known as "persistent data"
· Two ways: Volumes and Bind Mounts
· Volumes: make special location outside of container UFS
. Bind Mounts: link container path to host path


