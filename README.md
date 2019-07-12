# Docker - Perforce Helix p4d Server - Slim
A Docker image for Perforce's helix-p4d package installed via the Perforce package repository on Debian-slim.

The goal of this image is to be:
- Small (~118MB)
- Use only official resources (from the Perforce repository, no repo tars)
- Simple to build (requires the Dockerfile, no makefiles)
- Transparent in execution (the p4d server is not pre-configured in any way but to get it started as either a container or health-checked stack)

# How to use this image
## Starting...
### As a container
```shell
docker run --name perforce -p 1666:1666 --mount type=volume,src=perforce_root,dst=/root/perforceDB angusbjones/perforce-server-slim:latest
```

### As a stack
```shell
#if swarm mode hasn't already been initialised.
docker swarm init

docker stack deploy -c docker-compose.yml perforce
```

An example Docker compose file which includes a basic HEALTHCHECK (so that the container is reset if the p4d process stops responding to commands) can be found [here](https://github.com/angusbjones/docker-perforce-server/blob/master/docker-compose.test.yml).

## Configuring
This image is meant to reflect a clean install of the Perforce helix-p4d server so access can be achieved by simply using the p4Admin or p4v GUI tools, or the p4 command line tool, to create a new user. 

For example, the following command - run on the host, with the containers 1666 port published to the hosts 1666 port - will automatically (the default Perforce behaviour for depot commands) create the "admin" user and display their user specification.

```shell
p4 -H localhost -p 1666 -u admin user -o
```

### Security
This means the same care must be taken in securing the server as is taken when securing a regular install of the Perforce server. For instance, the current default installation:
- Allows users to create themselves.
- Allows the first user to create themselves to set themselves as the Super user.
- Allows users to be created without passwords.

## Useful Container Commands
While it's recommended to interact with the server via the GUI tools or the p4 command line tool on a client; it is of course possible to run commands directly on the container. Some useful commands follow:
### Disable user autocreate
```shell
docker exec perforce p4 -u USERNAME configure set dm.user.noautocreate=2
```

### Require strong passwords
```shell
docker exec perforce p4 -u USERNAME configure set security=2
```

### p4 help
```shell
docker exec perforce p4 help
```

### Add a user via a specification form
```shell
docker exec -i perforce p4 -u USERNAME user -i < p4-user-form.txt
```

This command redirects a file local to the host machine (here "./p4-user-form.txt") into the container's p4 user command. An example user form can be found [here](https://github.com/angusbjones/docker-perforce-server/blob/master/Examples/p4-user-form.txt).

### Set the protection table
```shell
docker exec -i perforce p4 -u USERNAME protect -i < p4-protections-form.txt
```

This command redirects a file local to the host machine (here "./p4-protections-form.txt") into the container's p4 protect command. An example protections form can be found [here](https://github.com/angusbjones/docker-perforce-server/blob/master/Examples/p4-protections-form.txt).

### Add a group via a specification form
```shell
docker exec -i perforce p4 -u USERNAME group -i < p4-group-form.txt
```

This command redirects a file local to the host machine (here "./p4-group-form.txt") into the container's p4 protect command. An example group form can be found [here](https://github.com/angusbjones/docker-perforce-server/blob/master/Examples/p4-group-form.txt).

### Login
```shell
docker exec -it perforce p4 -u USERNAME login
```