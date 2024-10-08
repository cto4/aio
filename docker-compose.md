# All In One server
All In One server. apache2, php, phpmyadmin and mariadb in one Alpine Linux docker image.

## Overview
[Read the full README.md for more informations](https://github.com/cto4/aio/blob/main/README.md)

## Run with docker compose

### Run all servers
```yml
version: "3.9"
services:
  aio:
    image: cto4/aio:latest
    container_name: aio
    volumes:
      - ./project:/var/www/localhost/htdocs
      - ./db:/run/mysqld
    ports:
      - 80:80
      - 8080:8080
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=aio # random one every run, if not set
    restart: unless-stopped
```

### Run MariaDB server only
```yml
version: "3.9"
services:
  aio-db:
    image: cto4/aio:mariadb
    container_name: aio-db
    volumes:
      - ./db:/run/mysqld
    ports:
      - 3306:3306
    environment:
      - MYSQL_ROOT_PASSWORD=aio # random one every run, if not set
    restart: unless-stopped
```

### Run Apache and PHP only
```yml
version: "3.9"
services:
  aio-web:
    image: cto4/aio:web
    container_name: aio-web
    volumes:
      - ./project:/var/www/localhost/htdocs
    ports:
      - 80:80
    restart: unless-stopped
```
