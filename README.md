# CI Pipeline Docker

This repository contains a simple Go API backed by PostgreSQL and a GitHub Actions
pipeline that builds a Dockerized database for tests.

## Development

- The database is configured via `docker-compose.yml`.
- The Postgres service uses a *named volume* (`postgres-data`)
  to persist data.  If you switch Postgres versions or want to start fresh, run:

  ```sh
  docker compose down -v    # removes containers and the postgres-data volume
  docker volume rm ci_pipeline_docker_postgres-data  # remove only the volume
  ```

  Older versions of the repository used a host bind mount (`./postgres-data`),
  which could contain data incompatible with newer images (e.g. v14 vs v17).
  You can safely delete that directory if it still exists locally.

- Environment variables used by the application:
  - `DB_HOST` (default `localhost`)
  - `DB_USER` (default `root` but frequently provided via CI secret or local `.env`)
  - `DB_PASSWORD` (default `root` but frequently provided via CI secret or local `.env`)
  - `DB_NAME` (default `root` but frequently provided via CI secret or local `.env`)
  - `DB_PORT` (default `5432`)

  In GitHub Actions you should create repository secrets named
  `DB_USER`, `DB_PASSWORD` and `DB_NAME`.  The workflow exports those values
  to both the postgres container and the test run.

  The CI job itself also exports `DB_HOST=localhost` before invoking the
  tests so they target the published container port.

  For local development you can either export the same environment
  variables in your shell or place them in a file named `.env` at the
  repository root.  `docker compose` automatically reads `.env` when
  substituting variables, so the following file is sufficient:

  ```env
  DB_HOST=localhost
  DB_PORT=5432
  DB_USER=foo   
  DB_PASSWORD=bar 
  DB_NAME=baz
  ```

  Then start the stack and run tests from the host:

  ```sh
  docker compose up -d            # uses values from .env (or shell vars)
  export DB_HOST=localhost        # tests need to know the host
  go test -v main_test.go
  ```

  Alternatively, skip `.env` and simply prefix the commands:

  ```sh
  DB_USER=foo DB_PASSWORD=bar DB_NAME=baz docker compose up -d
  DB_HOST=localhost go test -v main_test.go
  ```

## GitHub Actions

The workflow defined in `.github/workflows/go.yml` does the following:

1. Sets up Go.
2. Cleans any existing database data directory (locally if the workflow is reused).
3. Builds and starts the database container.
4. Runs `go test` against `main_test.go`.

The database container is reachable on `localhost:5432`.
