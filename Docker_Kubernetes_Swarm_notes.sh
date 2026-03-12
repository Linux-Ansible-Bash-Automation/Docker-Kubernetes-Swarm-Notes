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



