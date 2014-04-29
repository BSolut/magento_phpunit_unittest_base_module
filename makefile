DBNAME := magento
DBUSER := testing
DBHOST := localhost
WEBHOST := magento.local
BASE_DIR := $(shell pwd)
BASE_NAME := $(shell basename `pwd`)


all: composer-install tests

clean-magento:
	rm -fr ./public

clean: clean-magento
	rm -rf ./bin
	rm -rf ./tmp
	rm -fr ./vendor
	rm -f ./composer.lock
	rm -f ./composer.phar

./public:
	mkdir ./public

./tmp:
	mkdir ./tmp

composer.phar:
	curl -sS https://getcomposer.org/installer | php

composer.lock: composer.phar ./tmp ./public
	php composer.phar update --dev
	chmod a+x ./vendor/colinmollenhour/modman/modman

composer-install: composer.lock

magento-db:
	mysql -u$(DBUSER) -h $(DBHOST) -e 'DROP DATABASE IF EXISTS `$(DBNAME)`; CREATE DATABASE `$(DBNAME)`;'

public/.installed:
	make magento-db
	make clean-magento
	cp ./n98-magerun.yaml ~/.n98-magerun.yaml
	./bin/n98-magerun install \
	  --dbHost="$(DBHOST)" --dbUser="$(DBUSER)" --dbPass="" --dbName="$(DBNAME)" \
	  --installSampleData="yes" \
	  --useDefaultConfigParams="yes" \
	  --magentoVersionByName="bs-magento-ce-1.7.0.2" \
	  --installationFolder="./public" --baseUrl="http://$(WEBHOST)/"
	touch public/.installed

magento-install: public/.installed

./public/.modman:
	cd ./public && ../vendor/colinmollenhour/modman/modman init

./public/.modman/$(BASE_NAME): ./public/.modman
	cd ./public && ../vendor/colinmollenhour/modman/modman link $(BASE_DIR)
	touch ./public/.modman/$(BASE_NAME)

./public/.modman/magento-phpunit-extension: ./public/.modman
	cd ./public && ../vendor/colinmollenhour/modman/modman link --copy ../vendor/magetest/magento-phpunit-extension
	touch ./public/.modman/magento-phpunit-extension

./public/.modman/mage-test-modman: ./public/.modman
	cd ./public && ../vendor/colinmollenhour/modman/modman link --copy ../mage-test-modman
	touch ./public/.modman/mage-test-modman

magento-testing: ./public/.modman/magento-phpunit-extension ./public/.modman/mage-test-modman

module-install: magento-install magento-testing ./public/.modman/$(BASE_NAME)

tests: composer-install module-install
	@echo "Testing Module "$(BASE_NAME)
	@cd public && ../bin/phpunit

