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

## Permissions Issues

If you encounter any issues with filesystem permissions while visiting your application or running a container command, try completing the following steps:

- Bring any container(s) down with `docker-compose down`
- Open up the php, nginx, or composer Dockerfiles
- Modify the values in the `ENV` attributes to match the user and group of this folder in your system
- Re-build the containers by running `docker-compose build --no-cache`

Then, either bring back up your container network or re-run the command you were trying before, and see if that fixes it.