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

* Containers are usually immutable and ephemeral
* "immutable infrastructure": only re-deploy containers, never change
* This is the ideal scenario, but what about databases, or unique data?
* Docker gives us features to ensure these "separation of concerns"
* This is known as "persistent data"
* Two ways: Volumes and Bind Mounts
* Volumes: make special location outside of container UFS
* Bind Mounts: link container path to host path


Session 47: Persistent Data: Data Volumes
-----------------------------------------------------------------------------------------------------------------------------

# docker container runn -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=TRUE mysql
    {If we built mysql like this without using named volumes the volume name looks like below i.e: shah

[root@sandy007.docker ~]$ docker volume ls
DRIVER    VOLUME NAME
local     2d123e6386fee66df529508abea4ae21efafc659f426d9004338d64b3c03f735

# docker container run -d --name mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=TRUE -v mysql-data:/var/lib/mysql mysql
    {to run a new mysql container with a named volume called mysql-data that is mounted to /var/lib/mysql inside the container, this allows the data stored in /var/lib/mysql to persist even if the container is removed, and it also allows you to easily manage the volume with Docker commands.

# docker container inspect mysql
    { to check defualt volume directory for mysql container, you can find the volume information under the "Mounts" section of the container inspect output, it will show you the source and destination of the volume, as well as other details about the volume configuration.
    
Note: We can use mysql-data:/var/lib/mysql multiple times in different containers and they will all share the same data, this is useful for scenarios like running multiple mysql containers that need to access the same database files.

Note: Deleting the container will not delete the data in the volume, you can remove the container and the data will still be there when you run a new container with the same volume name.


Session 48: Shell Differences for Path expansion
-----------------------------------------------------------------------------------------------------------------------------
Here's the important part. Each shell may do this differently, so here's a cheat sheet for which OS and Shell your using. I'll be using $(pwd) on a Mac, but yours may be different!

This isn't a Docker thing, it's a Shell thing.

For PowerShell use: ${pwd} 

For cmd.exe "Command Prompt use: %cd%

Linux/macOS bash, sh, zsh, and Windows Docker Toolbox Quickstart Terminal use: $(pwd) 

Note, if you have spaces in your path, you'll usually need to quote the whole path in the docker command. 


Session 49: Persistent Data: Bind Mounting
-----------------------------------------------------------------------------------------------------------------------------
Persistent Data: Bind Mounting

* Maps a host file or directory to a container file or directory
* Basically just two locations pointing to the same file(s)
* Again, skips UFS, and host files overwrite any in container
* Can't use in Dockerfile, must be at container run
* ... run -v /Users/bret/stuff:/path/container (mac/linux)
* ... run -v //c/Users/bret/stuff:/path/container (windows)

# We are going to build nginx from Dockerfile, that's where we know file location of nginx container
[root@sandy007.docker dockerfile-sample-2]$ pwd
/root/Docker-mastery/udemy-docker-mastery/dockerfile-sample-2
[root@sandy007.docker dockerfile-sample-2]$ ls -l
total 12
-rw-r--r-- 1 root root  410 Feb 24 12:59 Dockerfile
-rw-r--r-- 1 root root 1178 Mar 17 16:35 index.html
-rw-r--r-- 1 root root   10 Mar 17 16:42 test.txt

# docker container run -d --name nginx -p 80:80 -v $(pwd):/usr/share/nginx/html nginx
    {to run a new nginx container and bind mount the current directory on the host to /usr/share/nginx/html inside the container, this allows you to serve the files in the current directory through nginx, and any changes you make to the files in the current directory will be reflected in the container immediately since it's a bind mount.

# docker container exec -it nginx bash
    {you can also check the contents of /usr/share/nginx/html to see the files from the host that are being served

Note: Bind mounts are great for development and testing scenarios where you want to have real-time access to the files on the host, but they can be less secure and less portable than volumes, so it's important to choose the right option based on your use case.


Session 50: Database passwords in Containers
-----------------------------------------------------------------------------------------------------------------------------
We all know databases usually need passwords, but since the dawn of Docker, the postgres image (and a few others like redis) has allowed you to do a simple docker run on it and it starts without a password. Sure you could set a password but it didn't require one.

In Feburary 2020 that changed, and will affect using postgres in this course (and my others). When running postgres now, you'll need to either set a password, or tell it to allow any connection (which was the default before this change).

For docker run, and the forthcoming Docker Compose sections, you need to either set a password with the environment variable:

POSTGRES_PASSWORD=mypasswd

Or tell it to ignore passwords with the environment variable:

POSTGRES_HOST_AUTH_METHOD=trust

Note this change was in the Docker Hub image, and not a change in postgres itself.


Session 51: Updated Postgres Version for Next video Assignment
-----------------------------------------------------------------------------------------------------------------------------
In the next video, you'll do an assignment to illustrate how easy it is to swap out one Docker image for another connected to the same volume. Since the video's release, Postgres has had new versions, so I thought I'd let you know you can do the same assignment with recent versions of Postgres. These newer versions also work on arm64 and Apple Silicon machines.

So, when you see the "old" and "new" versions of the Postgres SQL image in the Assignment video, you can replace them with these versions:

postgres:15.1
postgres:15.2


Session 52: Assignment: Database Upgrades with Named Volumes
-------------------------------------------------------------------------------------------------------------------------
Assignment: Named Volumes

* Database upgrade with containers
* Create a postgres container with named volume psql-data using
version 9.6.1
* Use Docker Hub to learn VOLUME path and versions needed to run it
* Check logs, stop container
* Create a new postgres container with same named volume using
9.6.2
* Check logs to validate
* (this only works with patch versions, most SQL DB's require manual commands to upgrade DB's to major/minor versions. i.e. it's a DB limitation not a container one)


Session 53: Assignment Answers: update for recent Postgres Changes
-------------------------------------------------------------------------------------------------------------------------

# docker volume create psql-data
    {to create a new named volume called psql-data

# docker container run -d --name psql-18 -e POSTGRES_PASSWORD=mysecretpassword -v psql-data:/var/lib/postgresql/ postgres:18
    {to run a new postgres container with the name psql-18, set the POSTGRES_PASSWORD environment variable to mysecretpassword, and mount the named volume psql-data to /var/lib/postgresql/ inside the container, using the postgres:18 image

# docker container logs psql-18
    {to check the logs of the psql-18 container to see if it started successfully

# docker container stop psql-18
    {to stop the psql-18 container

# docker container run -d --name psql-18.3 -e POSTGRES_PASSWORD=mysecretpassword -v psql-data:/var/lib/postgresql/ postgres:18.3
    {to run a new postgres container with the name psql-18.3, set the POSTGRES_PASSWORD environment variable to mysecretpassword, and mount the same named volume psql-data to /var/lib/postgresql/ inside the container, using the postgres:18.3 image, this will allow you to see if the data from the previous container is still accessible and if the upgrade was successful.

# docker container logs psql-18.3
    {to check the logs of the psql-18.3 container to see if it started successfully and if it can access the data from the previous container, you should see that the data is still there and the upgrade was successful since we used the same named volume for both containers.

Note: This assignment illustrates how using named volumes allows you to persist data across container instances, and how you can easily swap out one container for another while still retaining access to the same data, which is a key benefit of using Docker for managing stateful applications like databases.


Session 54: Assignment Answers: Database Upgrades with Named Volumes
-------------------------------------------------------------------------------------------------------------------------
We already covered this in the previous video, but just to reiterate, the key takeaway from this assignment is that by using named volumes, you can easily manage and persist data across different container instances, which is especially useful for stateful applications like databases. This allows you to perform upgrades or changes to your application without losing your data, and it also makes it easier to manage your application's lifecycle in a containerized environment.


Session 55: Permissions Across Multiple Containers
-------------------------------------------------------------------------------------------------------------------------

At some point you'll have file permissions problems with container apps not having the permissions they need. Maybe you want multiple containers to access the same volume(s). Or maybe you're bind-mounting existing files into a container.

Note that the below info is about pure Linux hosts, like production server setups. If you're using Docker Desktop locally, it will translate permissions from your host (macOS & Windows) into the container (Linux) automatically, but when working on pure Linux servers with just dockerd, no translation is made.

How file permissions work across multiple containers accessing the same volume or bind-mount:
File ownership between containers and the host are just numbers. They stay consistent no matter how you run them. Sometimes you see friendly user names in commands like ls but those are just name-to-number aliases that you'll see in `/etc/passwd` and `/etc/group`. Your host has those files, and usually, your containers will have their own. They are usually different. These files are really just for humans to see friendly names. The Linux Kernel only cares about IDs, which are attached to each file and directory in the file system itself, and those IDs are the same no matter which process accesses them.

When a container is just accessing its own files, this isn't usually an issue.

But for multiple containers accessing the same volume or bind-mount, problems can arise in two ways:

1. Problem one: The `/etc/passwd` is different across containers. Creating a named user in one container and running as that user may use ID 700, but that same name in another container with a different `/etc/passwd` may use a different ID for that same username. That's why I only care about IDs when trying to sync up permissions. You'll see this confusion if you're running a container on a Linux VM and it had a volume or bind-mount. If you do an ls on those files from the host, it may show them owned by ubuntu or node or systemd, etc. Then if you run ls inside the container, it may show a different friendly username. The IDs are the same in both cases, but the host will have a different passwd file than the container, and show you different friendly names. Different names are fine, because it's only ID that counts. Two processes trying to access the same file must have a matching user ID or group ID.

2. Problem two: Your two containers are running as different users. Maybe the user/group IDs and/or the USER statement in your Dockerfiles are different, and the two containers are technically running under different IDs. Different apps will end up running as different IDs. For example, the node base image creates a user called node with ID of 1000, but the NGINX image creates an nginx user as ID 101. Also, some apps spin-off sub-processes as different users. NGINX starts its main process (PID 1) as root (ID 0) but spawns sub-processes as the nginx user (ID 101), which keeps it more secure.

So for troubleshooting, this is what I do:
Use the command ps aux in each container to see a list of processes and usernames. The process needs a matching user ID or group ID to access the files in question.

Find the UID/GID in each containers `/etc/passwd` and `/etc/group` to translate names to numbers. You'll likely find there a miss-match, where one containers process originally wrote the files with its UID/GID and the other containers process is running as a different UID/GID.

Figure out a way to ensure both containers are running with either a matching user ID or group ID. This is often easier to manage in your own custom app (when using a language base image like python or node) rather than trying to change a 3rd party app's container (like nginx or postgres)... but it all depends. This may mean creating a new user in one Dockerfile and setting the startup user with USER. (see USER docs) The node default image has a good example of the commands for creating a user and group with hard-coded IDs:

RUN groupadd --gid 1000 node \\
        && useradd --uid 1000 --gid node --shell /bin/bash --create-home node

Note: When setting a Dockerfile's USER, use numbers, which work better in Kubernetes than using names.

Note 2: If ps doesn't work in your container, you may need to install it. In debian-based images with apt, you can add it with apt-get update && apt-get install procps


Session 56: Edit code running in Container with Bind Mounts
-------------------------------------------------------------------------------------------------------------------------
* Use a Jekyll "Static Site Generator" to start a local web server
* Don't have to be web developer: this is example of bridging the gap between local file access and apps running in containers
* source code is in the course repo under bindmount-sample-1
* We edit files with editor on our host using native tools
* Container detects changes with host files and updates web server
* start container with docker run -p 80:4000 -v $(pwd):/site bretfisher/jeky11-serve
* Refresh our browser to see changes
* Change the file in _posts\  and refrech browser to see changes


Session 57: Assignment Answers: Edit code running in Container with Bind Mounts
-------------------------------------------------------------------------------------------------------------------------   
[root@sandy007.docker bindmount-sample-1]$ pwd
/root/Docker-mastery/udemy-docker-mastery/bindmount-sample-1
[root@sandy007.docker bindmount-sample-1]$ docker container run -d -p 80:4000 -v $(pwd):/site bretfisher/jekyll-serve
    {to run a new container from the bretfisher/jekyll-serve image, publish port 80 to 4000, and bind mount the current directory to /site inside the container, this will allow you to serve the files in the current directory through the jekyll-serve application running in the container.

[root@sandy007.docker _posts]$ pwd
/root/Docker-mastery/udemy-docker-mastery/bindmount-sample-1/_posts
[root@sandy007.docker _posts]$ ls -l
total 4
-rw-r--r-- 1 root root 1378 Mar 18 06:56 2020-07-21-welcome-to-jekyll.markdown

Note: If we edit the file 2020-07-21-welcome-to-jekyll.markdown and save it, we can then refresh our browser to see the changes reflected in the web server running in the container, this is because of the bind mount we set up which allows real-time access to the files on the host from within the container. Here i tested changing title in the markdown file and it reflected in the browser after refreshing. This illustrates how bind mounts can be useful for development scenarios where you want to have real-time access to your files while they are being served by an application running in a container.









Section 7: Dockerfile ENTRYPOINT
===========================================================================================================================

Session 58: Intro: Review before ENTRYPOINT
-------------------------------------------------------------------------------------------------------------------------
- [Docs: Dockerfile reference](https://docs.docker.com/reference/dockerfile/)
- [Docs: ENTRYPOINT](https://docs.docker.com/reference/dockerfile/#entrypoint)


Session 59: Buildtime vs. Runtime
-------------------------------------------------------------------------------------------------------------------------
* Buildtime statements affect the files in the image or how the image is built
* Runtime statements are typically stored as metadata and affect the container
* Some statements affect how the image is built and also change container start behavior
* Overwrite statements replace any previous use
* Additive statements add to any previous use
* Know your base (FROM) images. Many statement types affect downstream images
* Understanding these effects helps troubleshoot Dockerfiles and container issues

Note: Check file in resources to know more


Session 60: What's an ENTRYPOINT?
-------------------------------------------------------------------------------------------------------------------------
* ENTRYPOINT executes a command on container start
* ENTRYPOINT is a Runtime statement, stored as metadata with an image
* Only the last ENTRYPOINT in a Dockerfile is used, making it an Overwrite type
* A container needs at least a CMD or an ENTRYPOINT to know how to start
* ENTRYPOINT requires more typing to overwrite compared to CMD, so it's rarely used by itself as a replacement for CMD
* You can overwrite ENTRYPOINT with docker run -- entrypoint "something" <image>

# docker run busybox
    {to run a new container from the busybox image, this will use the default command specified in the image's Dockerfile to start the container, which is usually something like "sh" or "echo", depending on the image. You can also specify a different command to run by adding it after the image name, for example: docker run busybox echo "Hello, World!" This will override the default command and run "echo Hello, World!" instead when the container starts.

# docker inspect  busybox
    {to inspect the busybox image and see its metadata, including the default command and entrypoint specified in its Dockerfile, this will give you information about how the container will start when you run it without specifying a command, and it will also show you if there is an ENTRYPOINT defined for the image. You can look for the "Cmd" and "Entrypoint" fields in the output to see what they are set to.

     "Cmd": [
         "sh"

# docker run -it busybox
    {to run a new container from the busybox image in interactive mode with a TTY, this will start the container and give you a shell prompt where you can interact with the container's file system and run commands. The default command for busybox is usually "sh", so when you run it like this, it will start a shell session inside the container.

# [root@sandy007.docker ~]$ cd Docker-mastery/udemy-docker-mastery/dockerfiles/entrypoint/entrypoint-1/

[root@sandy007.docker entrypoint-1]$ cat Dockerfile
FROM busybox:latest

CMD ["hostname"]

[root@sandy007.docker entrypoint-1]$ docker build -t hostname .

[root@sandy007.docker entrypoint-1]$ docker run hostname date
Tue Mar 24 02:39:02 UTC 2026

[root@sandy007.docker entrypoint-1]$ cat Dockerfile
FROM busybox:latest

ENTRYPOINT ["hostname"]

[root@sandy007.docker entrypoint-1]$ docker run entryhostname:latest
3569957f0707
[root@sandy007.docker entrypoint-1]$ docker run entryhostname:latest date
hostname: sethostname: Operation not permitted
[root@sandy007.docker entrypoint-1]$
[root@sandy007.docker entrypoint-1]$ docker inspect entryhostname

 "Entrypoint": [
     "hostname"

[root@sandy007.docker entrypoint-1]$ docker run --entrypoint date entryhostname:latest
Tue Mar 24 02:42:39 UTC 2026

Note: In the first Dockerfile, we used CMD to specify the default command as "hostname". When we ran the container with "docker run hostname date", it ignored the CMD and ran "date" instead. In the second Dockerfile, we used ENTRYPOINT to specify "hostname" as the entry point. When we ran the container without specifying a command, it executed "hostname" and printed the container's hostname. However, when we tried to run "date" with the entrypoint, it failed because ENTRYPOINT is not easily overridden like CMD. We had to use "--entrypoint date" to override the ENTRYPOINT and run "date" instead. This illustrates how ENTRYPOINT works and how it differs from CMD in terms of overriding behavior when running containers.


Session 61: Using Entrypoint and CMD together
-------------------------------------------------------------------------------------------------------------------------
[root@sandy007.docker ~]$ cd Docker-mastery/udemy-docker-mastery/dockerfiles/entrypoint/entrypoint-cmd-1/
[root@sandy007.docker entrypoint-cmd-1]$ cat Dockerfile
FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["curl"]

CMD ["--help"]

Takeaways: ENTRYPOINT + CMD
. If both ENTRYPOINT and CMD are set, they combine into a single command for starting the container
. For CLI tools, use ENTRYPOINT to set the base executable, while CMD should provide default arguments
· CMD can be easily overridden at docker run without replacing the ENTRYPOINT
. For pre-launch scripts, ENTRYPOINT should set the script, and CMD should set the final process
. ENTRYPOINT shell scripts should use exec "$@" to pass execution (PID1) to the CMD


Session 62: Shell vs Exec form
-------------------------------------------------------------------------------------------------------------------------
General Guidelines

RUN
Use Shell by default.

ENTRYPOINT
Always Exec, or CMD can't be used.

CMD
Use Exec by default, but sometimes Shell
form is needed for shell features.

ENTRYPOINT + CMD
Alwavs use Exec to avoid weird edge cases.


Takeaways: Shell vs Exec
- The RUN, ENTRYPOINT, and CMD instructions can be specified in shell form or exec form.
- Shell form will inject `/bin/sh -c' at the beginning of the command.
- Overwrite the shell that Docker injects with the SHELL statement, e.g. 'SHELL ["/bin/bash", "-c"]
- Shell form is needed for variable substitution, chaining commands, piping output, I/O redirection.
- Exec form (JSON syntax) runs the command without a shell.
- Exec form ensures ENTRYPOINT/CMD binary is PID 1 and receives signals.
- Exec form still passes ENVs from Dockerfile to processes started with ENTRYPOINT, CMD, and RUN.
- Don't mix forms between ENTRYPOINT and CMD, or weird things happen.

- General advice for which form to use:
    - RUN: Use Shell by default.
    - ENTRYPOINT: Always Exec, or CMD can't be used.
    - CMD: Use Exec by default, but sometimes Shell Form is needed for shell features.
    - ENTRYPOINT + CMD: Always use Exec to avoid weird edge cases.


Session 63: Assignment 1: create CLI utilities
-------------------------------------------------------------------------------------------------------------------------

Session 64: Assignment 1: Your Homewarrk
-------------------------------------------------------------------------------------------------------------------------
OK, it's time for you to dig into the README.md in this assignment ﻿and try to make the Dockerfiles yourself. The next lecture is me walking through the answer.


Session 65: Assignment 1 answer: create CLI utilities
--------------------------------------------------------------------------------------------------------------------------
[root@sandy007.docker cmatrix]$ pwd
/root/Docker-mastery/udemy-docker-mastery/dockerfiles/entrypoint/assignment01/cmatrix
[root@sandy007.docker cmatrix]$ cat Dockerfile
# use the README.md file for requirements to build this image
# If you get stuck, the answer/ directory has the solution
FROM alpine:3.23.3

RUN apk add --no-cache cmatrix

ENTRYPOINT ["cmatrix"]

CMD ["-abs", "-C", "red"]
Note: In this assignment, we created a Dockerfile that uses the alpine base image and installs the cmatrix utility. We set the ENTRYPOINT to "cmatrix" and provided default arguments with CMD. When we build and run this image, it will execute the cmatrix command with the specified arguments, creating a cool matrix-like effect in the terminal. You can override the CMD arguments when running the container to customize the behavior of cmatrix as needed.

[root@sandy007.docker cmatrix]$ docker build -t cmatrix .
[root@sandy007.docker cmatrix]$ docker run -it cmatrix

[root@sandy007.docker cmatrix]$ docker run -it --entrypoint sh cmatrix
/ # cmatrix --help


[root@sandy007.docker apachebench]$ pwd
/root/Docker-mastery/udemy-docker-mastery/dockerfiles/entrypoint/assignment01/apachebench
[root@sandy007.docker apachebench]$ cat Dockerfile
# use the README.md file for requirements to build this image
# If you get stuck, the answer/ directory has the solution

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y apache2-utils && \
    rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["ab"]

CMD ["-n", "10", "-c", "2", "https://www.google.com/"]

[root@sandy007.docker apachebench]$ docker build -t ab .
[root@sandy007.docker apachebench]$ docker run ab

Note: This will run the ApacheBench utility with the default arguments specified in the CMD instruction, which will perform a simple load test against Google's homepage. You can override the CMD arguments when running the container to customize the load test as needed. For example, you could run "docker run ab -n 100 -c 10 https://www.example.com/" to perform a more intensive load test against a different URL.


Session 66: Assignment 2 : Startup Scripts
-------------------------------------------------------------------------------------------------------------------------

Session 67: Assignment 2 : Your Homework
-------------------------------------------------------------------------------------------------------------------------
OK, it's time for you to dig into the README.md in this assignment and try to make the Dockerfile yourself. The next lecture is me walking through the answer.


Session 68: Assignment 2 Answers: Startup Scripts
-------------------------------------------------------------------------------------------------------------------------

[root@sandy007.docker assignment02]$ pwd
/root/Docker-mastery/udemy-docker-mastery/dockerfiles/entrypoint/assignment02

[root@sandy007.docker assignment02]$ cat Dockerfile
# use the README.md file for requirements to build this image
# If you get stuck, the answer/ directory has the solution
FROM python:slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

VOLUME /app/data

ENTRYPOINT ["./docker-entrypoint.sh"]

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]


[root@sandy007.docker assignment02]$ docker build --no-cache -t fastapi .
    {to build a new image from the Dockerfile in the current directory and tag it as fastapi:latest, using the --no-cache option to ensure that all layers are rebuilt from scratch, which can be useful for troubleshooting or when you want to make sure that all dependencies are freshly installed.
[root@sandy007.docker assignment02]$ docker run -p 8000:8000 fastapi
    {to run a new container from the fastapi image, publish port 8000 to the host, this will allow you to access the FastAPI application running inside the container through your web browser or API client by navigating to http://localhost:8000. The ENTRYPOINT script will be executed when the container starts, and it will run the uvicorn server with the specified command-line arguments to serve the FastAPI application.

http://192.168.43.102:8000/docs
    {to access the automatically generated API documentation for the FastAPI application, which is available at the /docs endpoint when you run the container and publish port 8000. You can use this interface to interact with your API and test its endpoints.













Section 8: Making it Easier with Docker Compose: The Multi-Container Tool   
===========================================================================================================================

Session 69: Docker Compose and the docker-compose.yml file
-------------------------------------------------------------------------------------------------------------------------
· Why: configure relationships between containers
· Why: save our docker container run settings in easy-to-read file
· Why: create one-liner developer environment startups
· Comprised of 2 separate but related things
· 1. YAML-formatted file that describes our solution options for:
    - containers
    - networks
    - volumes
· 2. A CLI tool docker-compose used for local dev/test automation with those YAML files

· Compose YAML format has it's own versions: 1, 2, 2.1, 3, 3.1
. YAML file can be used with docker-compose command for local docker automation or ..
· With docker directly in production with Swarm (as of v1.13)
. docker-compose -- help
· docker-compose. yml is default filename, but any can be used with
# docker-compose -f

Official docs: https://docs.docker.com/compose/overview/


Session 70: Compose V2
-------------------------------------------------------------------------------------------------------------------------
In 2022, Docker announced the General Availability of Docker Compose V2.

It supports all the same commands taught in this course and is meant to be fully backward compatible. It's auto-installed by Docker Desktop.

All you need to do is simply remove the dash from your Docker Compose commands:

docker-compose up becomes docker compose up, etc.

Behind the scenes, Docker has rebuilt the old docker-compose Python binary with go, the same language as the Docker CLI, and added Compose V2 as a CLI plugin rather than a separate command. It's now faster and more stable, and should "just work" as a drop-in replacement for the V1 docker-compose CLI.

So anywhere in this course that I type docker-compose, just replace that with docker compose


Session 71: Trying Out Basic Compose Commands
-------------------------------------------------------------------------------------------------------------------------
. CLI tool comes with Docker for Windows/Mac, but separate download for Linux
· Not a production-grade tool but ideal for local development and test
. Two most common commands are
    - docker-compose up # setup volumes/networks and start all containers
    - docker-compose down # stop all containers and remove cont/vol/net
. If all your projects had a Dockerfile and docker-compose. yml then "new developer onboarding" would be:
    - git clone github.com/some/software
    - docker-compose up

root@sandy010.DNS:~/Docker-mastery/udemy-docker-mastery/compose-sample-2# pwd
/root/Docker-mastery/udemy-docker-mastery/compose-sample-2

root@sandy010.DNS:~/Docker-mastery/udemy-docker-mastery/compose-sample-2# ls -l
total 8
-rw-r--r-- 1 root root 599 Feb 24 12:59 docker-compose.yml
-rw-r--r-- 1 root root 298 Mar 31 06:07 nginx.conf

# docker compose up
    {to start the services defined in the docker-compose.yml file, this will create and start the containers, networks, and volumes as specified in the YAML file. You can also use the -d flag to run the containers in detached mode, allowing you to continue using your terminal while the services are running.

# docker compose logs
    {to view the logs of the services defined in your docker-compose.yml file, this will show you the output from all the containers that are part of your Compose application, allowing you to see what's happening inside each container and troubleshoot any issues that may arise. You can also specify a particular service to view its logs by using docker compose logs <service_name>.

# docker compose up -d
    {to start the services defined in the docker-compose.yml file in detached mode, this will run the containers in the background and return control to your terminal, allowing you to continue working while the services are running. You can check the status of the containers with docker compose ps and view their logs with docker compose logs as needed.

# docker compose --help
    {to view the help information for the docker compose command, this will show you a list of available subcommands and options that you can use with docker compose to manage your Compose applications, including how to start, stop, and view logs for your services, as well as other useful commands for working with Docker Compose.

# docker compose top
    {to view the running processes inside the containers of your Compose application, this will show you a list of processes running in each container, similar to the output of the top command in Linux, allowing you to see what is currently running inside your containers and monitor their resource usage.

# docker compose down
    {to stop and remove the containers, networks, and volumes defined in your docker-compose.yml file, this will clean up all the resources associated with your Compose application, allowing you to start fresh the next time you run docker compose up. You can also use additional flags with docker compose down to specify whether to remove volumes or images as well.


Session 72: Version Dependencies in Multi Tier Apps
-------------------------------------------------------------------------------------------------------------------------
App versions in Docker
Now that you're learning Docker Compose for managing multi-container apps, it's important to remember that every app with dependencies, will also have version requirements for those dependencies.

If you add an app and a database to a Compose file, then that app is going to have specific database versions it is compatible with.

Version dependencies aren't new, so they aren't technically a Docker thing, but we *do* use Docker and Compose to control versions of apps like Drupal, PostgreSQL, MySQL, Redis, Wordpress, etc.

Therefore, when building your Dockerfile and docker-compose.yml file, remember that you'll need to check the compatible versions in that apps documentation.

Coming up
In the next few Assignments, you'll be using a Drupal web server with a compatible database server. For this course, I pick specific versions of these dependencies so they are certain to work together. I've done the research and found which versions work together through reading and testing.

You may need to do the same, especially if you want to use versions together that I haven't tested.  I will often leave old versions in this course (as long as they still work) for several reasons:

1. During your career, you'll be running lots of old versions of apps. It's worthwhile learning about how various app versions work together with other apps. 
2. Learning "the latest version of every sample app" isn't the focus of this course, but rather how to manage *any* versions of an app in Docker and Kubernetes.

Drupal changes
Due to recent breaking changes in Drupal, be sure you're using the below versions in docker commands and YAML, so that it'll work as expected. While a lecture video might show a slightly older version, know that any code examples and answer files in the course repository have been updated to reflect these versions:

drupal:9
postgres:14
Now let's build some Compose files!


Session 73: Compose Assignments
-------------------------------------------------------------------------------------------------------------------------
In the next lecture, you'll start one of two Compose assignments in this Section. This first one should be done in the compose-assignment-1 directory from the source code repository you cloned at the start of the course. In the answer video to that assignment, I mistakenly use the compose-assignment-2 directory, so pretend my directory ends in a one 🤭.

Note that these two Compose assignment lectures are named according to the directory they use, to help avoid confusion.


Session 74: Compose Assignment 1: Build a Compose File For a Multi-Container project
-------------------------------------------------------------------------------------------------------------------------
· Build a basic compose file for a Drupal content management system website. Docker Hub is your friend
· Use the drupal image along with the postgres image
· Use ports to expose Drupal on 8080 so you can localhost:8080
· Be sure to set POSTGRES_PASSWORD for postgres
· Walk though Drupal setup via browser
· Tip: Drupal assumes DB is localhost, but it's service name
· Extra Credit: Use volumes to store Drupal unique data


Session 75: Compose Assignment 1: Build a Compose File For a Multi-Container project:
-------------------------------------------------------------------------------------------------------------------------
root@sandy010.DNS:~/Docker-mastery/udemy-docker-mastery/compose-assignment-2# pwd
/root/Docker-mastery/udemy-docker-mastery/compose-assignment-2
root@sandy010.DNS:~/Docker-mastery/udemy-docker-mastery/compose-assignment-2# cat docker-compose.yml
# create your drupal and postgres config here, based off the last assignment
version: '2'

services:
  drupal:
    image: drupal
    ports:
      - "8080:80"
    volumes :
      - drupal-modules:/var/www/html/modules
      - drupal-profiles:/var/www/html/profiles
      - drupal-sites:/var/www/html/sites
      - drupal-themes:/var/www/html/themes
  postgres:
    image: postgres
    environment:
      - POSTGRES_PASSWORD=mypasswd

volumes :
  drupal-modules:
  drupal-profiles:
  drupal-sites:
  drupal-themes:


# docker compose up
    {to start the services defined in the docker-compose.yml file, this will create and start the Drupal and PostgreSQL containers, set up the necessary volumes for Drupal data persistence, and expose Drupal on port 8080. You can then access Drupal through your web browser at http://localhost:8080 and complete the setup process, connecting it to the PostgreSQL database using the service name "postgres" as the database host. The volumes will ensure that any changes you make in Drupal are persisted even if you stop and remove the containers.

# docker compose ps

# docker compose down --help

# docker compose down -v
    {to stop and remove the containers, networks, and volumes defined in your docker-compose.yml file, this will clean up all the resources associated with your Compose application, allowing you to start fresh the next time you run docker compose up. The -v flag will also remove the named volumes that were created for Drupal data persistence, so be cautious when using this if you want to keep your Drupal data.


Session 76: Adding Image Building to Compose Files
-------------------------------------------------------------------------------------------------------------------------


