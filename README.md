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
  - `DB_USER` (default `root`)
  - `DB_PASSWORD` (default `root`)
  - `DB_NAME` (default `root`)
  - `DB_PORT` (default `5432`)

  The CI workflow sets `DB_HOST=localhost` before running tests.

## GitHub Actions

The workflow defined in `.github/workflows/go.yml` does the following:

1. Sets up Go.
2. Cleans any existing database data directory (locally if the workflow is reused).
3. Builds and starts the database container.
4. Runs `go test` against `main_test.go`.

The database container is reachable on `localhost:5432`.
