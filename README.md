This project is a minimal pyramid + gunicorn application to use the `c2cwsgiutils.sqlalchemylogger` handler
for logs in a containerized application using gunicorn as wsgi server.

Everything is configured in `development.ini`.

# To run the docker application

## Prerequisites

Run a localhost postgresql database with a `test` database

```shell
docker run --rm --name=local_db --env=POSTGRES_PASSWORD=password --env=POSTGRES_USER=postgres --env=POSTGRES_DB=postgres --env=PGPASSWORD=www-data --env=PGUSER=www-data --env=PGDATABASE=geomapfish --detach--publish=5432:5432 postgis/postgis:12-3.2-alpine
```

Create the `test` database:

```shell
PGPASSWORD=password psql -h localhost -p 5432 -U postgres -c "CREATE DATABASE test;"
```

## Run the server

```shell
# This will build the container and execute it
make docker-serve
```

The server is started on `http://localhost:8080`

To create a `200 OK` request:

```shell
curl localhost:8080/
```

To create a `400 Bad Request`:

```shell
curl localhost:8080/
```

To create any `404 Not Found`:

```shell
curl localhost:8080/anything-else
```

## Access logs

Log into the database

```shell
PGPASSWORD=password psql -h localhost -p 5432 -U postgres test
```

View all the access logs

```sql
SELECT * FROM xyz.accesslogs;
```

## Check the server logs

```shell
# This follows the logs
make docker-logs-follow
```

If you run the `/fail` route, you will trigger an exception and see it in the server logs

```shell
curl localhost:8080/fail
```

# To run the project locally

```shell
make install
make serve
```

to check the logger try:

```shell
curl localhost:6543/
```

you should see the results both on console output and find them in SQL DB:

```shell
sqlite3 logger_db.sqlite3
```

and then

```sql
SELECT * FROM logs;
```

to see only `wsgi` apache-like logs:

```sql
SELECT * FROM logs WHERE logger like 'wsgi';
```

or only `wsgi` logs issued after a given time:

```sql
SELECT * FROM logs WHERE created_at >= '2019-11-13 20:50:00' AND  logger like 'wsgi';
```
