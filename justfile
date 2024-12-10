default: dev

dev:
  crystal run src/kemal-playground.cr

# https://github.com/NixOS/nixpkgs/issues/83770
# https://stackoverflow.com/a/74986582/1212807
db-start:
  test -d postgres || initdb --pgdata=postgres
  PGHOST=/tmp pg_ctl --pgdata=postgres --options="-k /tmp" --wait start

db-migrate:
  PGHOST=/tmp psql -d postgres -a -f migrations/create_todos.sql

db-repl:
  PGHOST=/tmp psql -d postgres
