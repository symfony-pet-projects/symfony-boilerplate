
PWD					?= pwd_unknown
SHELL				:= /bin/bash
THIS_FILE      		:=	$(lastword $(MAKEFILE_LIST))


# If the first argument is "run"...
ifeq (run,$(firstword $(MAKECMDGOALS)))
	# use the rest as arguments for "run"
	RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
	# ...and turn them into do-nothing targets
	$(eval $(RUN_ARGS):;@:)
endif


.PHONY: all info cache-clear cache-warmup cache migrate fixtures resolve elastica elastica-create up test

all: info
cache: composer-autoload cache-clear cache-warmup

cache-clear:
	php bin/console doctrine:cache:clear-metadata
	php bin/console doctrine:cache:clear-query
	php bin/console doctrine:cache:clear-result
	php bin/console cache:pool:clear cache.system
	php bin/console cache:pool:clear cache.annotations
	php bin/console redis:flushdb -n --client=default
	php bin/console cache:clear

migrate:
	php bin/console doctrine:migrations:migrate --no-interaction

elastica:
	php bin/console fos:elastica:populate --no-interaction

elastica-create:
	php bin/console fos:elastica:create --no-interaction

fixtures:
	case $${APP_ENV} in dev|test) php bin/console doctrine:fixtures:load --append --group=demo ;; *) echo "FIXTURES SKIPPED";; esac

assets:
	php bin/console assets:install --no-interaction

cache-warmup:
	php bin/console cache:warmup --no-interaction

composer-autoload:
	composer dump-autoload -o --apcu

info:
	php bin/console about

resolve:
	shell /srv/bin/init-lookup

up:
	docker-compose up -d

down:
	docker-compose down

test:
	php vendor/bin/codecept run

test-coverage:
	php vendor/bin/codecept run --coverage --coverage-xml --coverage-html

# fos:
# 	php bin/console fos:elastica:populate --ignore-errors

code-quality:
	php vendor/bin/php-cs-fixer fix --dry-run --diff --config=.php_cs src tests

beauty:
	php vendor/bin/php-cs-fixer fix --config=.php_cs src tests

psalm-analyse:
	php vendor/bin/psalm

phan-analyse:
	php vendor/bin/phan

quality-check:
	make code-quality
	make psalm-analyse
	make phan-analyse
	make test
