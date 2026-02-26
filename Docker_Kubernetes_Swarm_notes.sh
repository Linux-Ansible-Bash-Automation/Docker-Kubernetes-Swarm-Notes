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







