Magento Module Example Stub
=========

This magento module provides a stub for a magento module with *ready to go  unit testing* capabilities by combining multiple exising open source project projects.

## Requirements

* PHP 5.3+
* *nix (make, curl)
*

## Installation

It is ready to be forked module stub. The module itself can be easily installed via modman or composer on a composer/modman ready magento.
The testing itself is using modman to install the module to a magento which also will be automaticly installed during the testing process to a local module subdirectory - this requires a working modman config even if you plan to use the module with composer only later.

## Running the Tests
```
make
```

This will:
* download composer
* run composer to install magetest/magento-phpunit-extension, n98-magerun, modman, phpunit
* install a magento (using the db connection details from the makefile)
* install the magetest/magento-phpunit-extension module to magento using modman (copy mode)
* install some missing files from magento-phpunit-extension to magento using modman (copy mode)
* install the module itself to magento using modman (symlink)
* run the magento-phpunit-extension default unit tests

## How it works

The Stub combines multiple project.

* Make
    * Easy way to initalize an setup a Test Environment (a fancy bash script if you will)
* Composer
    * Install all needed Components for Testing
* Magento Community Edition - http://www.magentocommerce.com/download 
* https://github.com/netz98/n98-magerun as handy shell interface to magento to have an easy way to install a magento via shell
* https://github.com/colinmollenhour/modman to install plugins to the n98  magento install
* https://github.com/sebastianbergmann/phpunit/ as Unittest Framework
* https://github.com/MageTest/Mage-Test as Unittest Basis for Magento
* and it is https://github.com/magento-hackathon/magento-composer-installer compatible to allow composer like install of the module lateron (not used for pure unit testing)


## How to start customisation

### Config
There is special composer config where you should think about putting in your own github-oauth key. The preferred-install is set to make as little as possible github api calls.

```
 "config": {
        "bin-dir": "bin",
        "preferred-install": "dist",
        "github-protocols:": ["https", "ssh", "git"],
        "github-oauth": {"github.com": "xxxxx"},
        "cache-files-maxsize": "2048MiB"
    },
    
```