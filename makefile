.PHONY: build test

ADMIN_NAME ?= sheldon
ADMIN_EMAIL ?= sheldon@newapp.com
ADMIN_PASSWORD ?= password

CLIENT_NAME ?= leonard
CLIENT_EMAIL ?= leonard@newapp.com
CLIENT_PASSWORD ?= supadupa42!

# Initialization ===============================================================
copy-conf:
	@cp -n ./config/development-dist.js ./config/development.js | true

install: copy-conf
	@echo "Installing Node dependencies"
	@npm install
	@echo "Installing Selenium server"
	@./node_modules/.bin/selenium-standalone install --version=2.48.2

# Deployment ===================================================================
build:
	@./node_modules/.bin/webpack --progress

clean:
	git clean -nxdf

install-prod: install
	@echo "Copy production conf"
	@cp -n ./config/production-dist.js ./config/production.js | true

# Development ==================================================================
run-dev:
	@node_modules/.bin/pm2 start ./config/pm2_servers/dev.json
stop-dev:
	@node_modules/.bin/pm2 stop ./config/pm2_servers/dev.json

restart-frontend-dev:
	@node_modules/.bin/pm2 restart bpm_frontend-dev
	@echo "Webpack dev restarted"
restart-api-dev:
	@node_modules/.bin/pm2 restart bpm_api-dev
	@echo "API dev restarted"

run-api:
	@node ./api/index.js
run-frontend:
	@./node_modules/.bin/webpack-dev-server  \
		--no-info \
		--colors \
		--devtool cheap-module-inline-source-map \
		--hot  \
		--inline

servers-monitoring:
	@node_modules/.bin/pm2 monit
servers-list:
	@node_modules/.bin/pm2 list
servers-stop-all:
	@node_modules/.bin/pm2 stop all
servers-clear-all:
	@node_modules/.bin/pm2 stop all
	@node_modules/.bin/pm2 delete all
	@node_modules/.bin/pm2 flush

log-frontend-dev:
	@node_modules/.bin/pm2 logs bpm_frontend-dev
log-api-dev:
	@node_modules/.bin/pm2 logs bpm_api-dev

# Tests ========================================================================
build-test:
	@NODE_ENV=test ./node_modules/.bin/webpack --progress

test-api-unit:
	@NODE_ENV=test ./node_modules/.bin/mocha --require "./babel-transformer" --require=co-mocha --recursive ./src/api/

test-api-functional:
	@NODE_ENV=test NODE_PORT=3010 ./node_modules/.bin/mocha --require "./babel-transformer" --require=co-mocha --recursive ./e2e/api

test-frontend-unit:
	@NODE_ENV=test ./node_modules/.bin/mocha --compilers="css:./webpack/null-compiler,js:babel-core/register" --recursive ./src/frontend/js/**/*.spec.js

test-isomorphic-unit:
	@NODE_ENV=test ./node_modules/.bin/mocha --compilers="js:babel-core/register" --recursive ./src/isomorphic/{,**/}*.spec.js

test-frontend-functional:
	# TODO: restore when implemented
	# @NODE_ENV=test ./node_modules/.bin/babel-node ./bin/loadFixtures.js
	@make build-test
	@node_modules/.bin/pm2 start ./config/pm2_servers/test.json
	@node_modules/.bin/nightwatch --config="./e2e/frontend/nightwatch.json"
	@node_modules/.bin/pm2 stop ./config/pm2_servers/test.json

test:
	@cp -n ./config/test-dist.js ./config/test.js | true
	make test-frontend-unit
	make test-api-unit
	# TODO: restore when implemented
	# make test-isomorphic-unit
	make test-api-functional
	make test-frontend-functional

# Migrations ===================================================================
migrate:
	@./node_modules/.bin/db-migrate \
		--migrations-dir=./src/api/lib/migrations \
		--config=config/database.js \
		-e api \
		up

create-migration:
	@./node_modules/.bin/db-migrate \
		--migrations-dir=./src/api/lib/migrations \
		--config=config/database.js \
		-e api \
		create migration

# Binaries =====================================================================
create-admin:
	./node_modules/babel-cli/bin/babel-node.js ./bin/createAdmin.js ${ADMIN_NAME} ${ADMIN_EMAIL} ${ADMIN_PASSWORD}

create-client:
	# TODO: ensure we create a simple user and not an admin
	./node_modules/babel-cli/bin/babel-node.js ./bin/createAdmin.js ${CLIENT_NAME} ${CLIENT_EMAIL} ${CLIENT_PASSWORD}
