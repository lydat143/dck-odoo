### Description

Odoo dev image for devs

- Based `buildpack-deps:xenial`
- Use `supervisord` as PID1
- Included many utils for developer: `tmux`, `screen`, `tmuxp`, `tig`, network tools
- Use Oh-My-ZSH & ZSH by default
- Odoo environment ready with python libs and `wkhtmltopdf`
- Python dev utils included:
    + [pew](https://github.com/berdario/pew):  A tool to manage multiple virtual environments
    + [ptpython](https://github.com/jonathanslenders/ptpython): A better Python REPL
    + [pgcli](http://pgcli.com/): command line interface for Postgres with auto-completion and syntax highlighting.
    + [pg_activity](https://github.com/julmon/pg_activity): top like application for PostgreSQL server activity monitoring.
    + Python linters: `pylint`, `pep8`, `autopep8` and `flake8`

### Usage

- Create `.env` file with following content before run `docker-compose up -d`

```bash
# PostgreSQL version
PGVER=10
# Odoo container tag
TAG=latest
```

Details [here](https://docs.docker.com/compose/environment-variables/) and [here](https://docs.docker.com/compose/compose-file/#variable-substitution)


### Services

- `odoo`: Odoo dev env. It can be access via address [http://localhost:8069](http://localhost:8069) (8071, 8072 and 8073 is reserved ports)

- `db`: PostgreSQL 10 database server. It bind to host port `5432`, so we can access using `localhost:5432`

- `pgadmin4`: PgAdmin4 for manage database server. It's bind to `localhost` only [http://localhost:5050](http://localhost:5050)
