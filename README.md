# The Docker Tutorial
This is the source code behind the Laracasts series [The Docker Tutorial](https://laracasts.com/series/the-docker-tutorial), and features all of the files and code available in those videos. If any additions to the series are made, this code will be modified to include them!

## Basic Usage

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system, and then clone this repository.

Next, navigate in your terminal to the directory you cloned this, and spin up the containers for the web server by running `docker-compose up -d --build site`.

After that completes, follow the steps from the [src/README.md](src/README.md) file to get your Laravel project added in (or create a new blank one).

Bringing up the Docker Compose network with `nginx` instead of just using `up`, ensures that only our site's containers are brought up at the start, instead of all of the command containers as well. The following are built for our web server, with their exposed ports detailed:

- **nginx** - `:80`
- **mysql** - `:3306`

Three additional containers are included that handle Composer, NPM, and Artisan commands *without* having to have these platforms installed on your local computer. Use the following command examples from your project root, modifying them to fit your particular use case.

- `docker-compose run --rm composer update`
- `docker-compose run --rm npm run dev`
- `docker-compose run --rm artisan migrate`

## Permissions Issues (more info further down as well)

If you encounter any issues with filesystem permissions while visiting your application or running a container command, try completing the following steps:

- Bring any container(s) down with `docker-compose down`
- Open up the php, nginx, or composer Dockerfiles
- Modify the values in the `ENV` attributes to match the user and group of this folder in your system
- Re-build the containers by running `docker-compose build --no-cache`

Then, either bring back up your container network or re-run the command you were trying before, and see if that fixes it.

## Commands as seen in the video (with extra infos)

`docker build . --no-cache -t <tag_name>` &nbsp;&nbsp;<tag_name> is what you define yourself. for demo was json-server. Should include the tag version. Builds the ignoring cache and creates a tag <tag_name>. Tag is used to push the image to Docker Hub. As well for easy starting  
`docker image list` &nbsp;&nbsp;Lists all images, to copy image_id for say starting it later
`docker run --rm -p 3000:3000 <tag_name>` &nbsp;&nbsp;e.g. json-server or laravel-nginx for tag_name e.g. docker run --rm -p 3000:3000 json-server  
`docker ps`&nbsp;&nbsp;List all containers that are running  
`docker stop <container_id>` &nbsp;&nbsp;Stop a container  
`docker run --rm -p 8080:80 laravel-nginx`&nbsp;&nbsp;`docker run --rm -p 8080:80 -v /home/myuser/IdeaProjects/dockerTutorial/src:/var/www/html/public laravel-nginx`&nbsp;&nbsp;run a container with a volume mount aka you expose your local folder to the container. /your/local/folder/:/folder/in/container  
`docker-compose ps`&nbsp;&nbsp;List all containers with ports in current directory from docker-compose.yml  
`docker-compose up --build` &nbsp;&nbsp;Builds the containers and starts them  
`docker-compose build composer` &nbsp;&nbsp;builds the composer container which is our custom container see composer.dockerfile  
`docker-compose build --no-cache` &nbsp;&nbsp;builds all containers wo cache  
`docker-compose run --rm composer create-project laravel/laravel .` &nbsp;&nbsp;this leads for me to permission issues, next command worked better, but wasn't working completely either  
`docker-compose run --rm --user 1001 composer create-project laravel/laravel .`&nbsp;&nbsp;where 1001 is the user id of user from your local system. See next chapter  

This is where eventually one needs to fix issues


### PERMISSION ISSUES

`echo $(id -u)`&nbsp;&nbsp;Prints the user id of the current user  
`echo $(id -g)`&nbsp;&nbsp;Prints the group id of the current user  

used to run command from above&nbsp;&nbsp;  
`docker-compose run --rm --user 1001 composer create-project laravel/laravel .`
To fix my permission issues adding  
`RUN apk add shadow && usermod -u 1001 yourusername && groupmod -g 1001 yourusername` &nbsp;&nbsp;did help. Add that command after the adduser command in php.dockerfile and composer.dockerfile. I did the same for mysql.dockerfile that wasn't part of the series

`mysql.dockerfile`    
```docker
FROM mariadb:10.5

# To be changed here
ENV MYSQL_UID 1001
ENV MYSQL_GID 1001

RUN usermod -u $MYSQL_UID mysql; groupmod -g $MYSQL_GID mysql;

RUN chown -R mysql:mysql /var/lib/mysql /var/run/mysqld
```

Add it as well to the docker-compose.yml


### Log into containers via shell to check stuff / debug
`docker run -it --entrypoint /bin/sh 9860e3c5ddec`&nbsp;&nbsp;log into the container that is not running where 9860e3c5ddec is image id   
`docker exec -it 9860e3c5ddec /bin/sh`  log into running container that is running where 9860e3c5ddec is container id, you can use the container name as well
`docker-compose run --rm npm install`&nbsp;&nbsp;  
`docker image rm <image_id>`&nbsp;&nbsp;cleanup  
`mkcert laravel-docker.test`&nbsp;&nbsp;creates a self signed certificate for the domain laravel-docker.test. Be sure to add an entry into the hosts file as well. Installation for linux is here https://kifarunix.com/create-locally-trusted-ssl-certificates-with-mkcert-on-ubuntu-20-04/  
`docker-compose -f docker-compose.yml -f docker-compose.prod.yml up --build nginx`&nbsp;&nbsp;overwriting development config with production values  
`docker-compose run --rm php -i | grep opache`&nbsp;&nbsp;check for opcache  
`docker-compose logs mysql`&nbsp;&nbsp; in case you have issues with a container like mysql, this will show the logs from mysql container, you can read the error there


