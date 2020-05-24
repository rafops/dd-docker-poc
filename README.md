# Datadog Docker POC

## Set Datadog API key environment

Generate an API key in https://app.datadoghq.com/account/settings#api

```
export DD_API_KEY=…
```

## Build and compose

```
docker-compose build --no-cache --pull
docker-compose up
```

## Create database and user for myapp

```
docker exec -it dd_docker_poc_db_1 psql -U postgres -c "CREATE DATABASE myapp_development"
docker exec -it dd_docker_poc_db_1 psql -U postgres -c "CREATE USER myappdbusr WITH ENCRYPTED PASSWORD 'myappdbpwd'"
docker exec -it dd_docker_poc_db_1 psql -U postgres -c "GRANT ALL PRIVILEGES ON DATABASE myapp_development TO myappdbusr"
```

## Scaffold and migrate

```
docker exec -it dd_docker_poc_myapp_1 rails generate scaffold HighScore game:string score:integer
docker exec -it -e DATABASE_URL=postgres://myappdbusr:myappdbpwd@db/myapp_development dd_docker_poc_myapp_1 rails db:migrate
```
