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
psql() { docker exec -it dd-docker-poc_db_1 psql -U postgres $@ }
psql -c "CREATE DATABASE myapp_development"
psql -c "CREATE USER myappdbusr WITH ENCRYPTED PASSWORD 'myappdbpwd'"
psql -c "GRANT ALL PRIVILEGES ON DATABASE myapp_development TO myappdbusr"
```

## Run migrations

```
docker-compose run --rm app rails db:migrate
```
