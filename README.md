node-stack
==========

this stack provides all necessary tools for developing Node APIs. It is built on Docker and several Node modules, including main module [knapp](https://www.npmjs.com/package/knapp) which is designed to cover all basic functionality of API.

This documentation will refer to `coffee` files only. There is a tool prepared for compiling coffee to JavaScript (described below) and from the server point of view it doesn't matter whether CoffeeScript or JavaScript is used.

# Prerequisites

* GIT
* Docker
* ansible

# Installation

Create a directory for node-stack and `cd` into it. Then:

1. run `git clone https://bitbucket.org/usertech/node-stack.git .`
2. configure `.install_conf.yml`
3. run `./install`

This command will install node-stack in current directory.

Install script will pull 2 repositories with docker images and build them. These repositories are:

* [ns-docker-nginx](https://github.com/prokvk/ns-docker-nginx)
* [ns-node-server](https://github.com/prokvk/ns-node-server)

After you've ran installation script you need to do the following:

1. add symlink to `$NODESTACK_PATH/nodestack` to one of `bin` folders in your `$PATH`
2. "source" `$NODESTACK_PATH/.env` in your `.bashrc` / `.bash_profile`
3. "source" `$NODESTACK_PATH/ns_bash_completion` in your `.bashrc` / `.bash_profile`

Points 1 and 3 are optional. Obviously without adding symlink you will have to use full path in your commands. Examples in this README will assume that `nodestack` command is available. Also as name suggests, `ns_bash_completion` provides bash completion which won't be available without point 3.

# Test your installation

Run command `install-test`

All you should see is `Install test successful`

# How does it work

* NGINX container is used as a proxy for both API and DOC.
* Node server container is used for running server with API, installing modules, compiling coffee, running tests...
* [knapp](https://www.npmjs.com/package/knapp) module has prepared tools for performing automated tests and generating static documentation.

Every time you run the server (with `nodestack runs`) NGINX config files are generated and NGINX is started/restarted before node server container starts.

`nsconf.yml` and `local.nsconf.yml` config files are included in every project. By default, `nsconf.yml` has its `local_conf` var set to `local.nsconf.yml`. That means it will use this file to run locally. `local.nsconf.yml` is also in `.gitignore`. These config files hold all configuration for given project (not API itself, which has its own configs).

The whole stack is controlled by `nodestack` binary. `ns_bash_completion` provides bash completion for easy use. Available commands are:

* `nodestack create-project` - copy (and setup) files from new project template
* `nodestack init-project` - install modules based on `nsconf.yml` config file
* `nodestack runs` - run server
* `nodestack stops` - stop server
* `nodestack gendoc` - generate documentation
* `nodestack atest` - run automated tests
* `nodestack install-test` - validate nodestack installation
* `nodestack npmi` - npm install
* `nodestack gcompile` - grunt task for compiling CoffeeScript files into JS
* `nodestack printsshkey` - print nodestack public SSH key
* `nodestack deploy` - deploy project to remote
* `nodestack pull` - pull & setup an existing nodestack project
* `nodestack s3s_cu` - s3 secrets - create AWS IAM user
* `nodestack s3s_cuak` - s3 secrets - create AWS IAM user access keys (AWS security credentials will be saved in `NODESTACK_PATH/ansible` dir)
* `nodestack s3s_cb` - s3 secrets - create private encrypted S3 bucket
* `nodestack s3s_ugba` - s3 secrets - grant bucket access to specified user
* `nodestack s3s_full` - s3 secrets - whole s3 secrets flow (cu, cuak, cb, ugba)

**IMPORTANT:** All commands need to be run from project root, that is `$NODESTACK_PROJECTS_PATH/project-folder/`, which contains `nsconf.yml` and `local.nsconf.yml` files created with `nodestack create-project` command. Exceptions are:

* `nodestack stops` - can be run from anywhere
* `nodestack install-test` - can be run from anywhere
* `nodestack s3s_` commands - can be run from anywhere

# Init new project

1. Create new folder for your project inside `$NODESTACK_PROJECTS_PATH` and `cd` into it
2. run `nodestack create-project`
3. open and setup `nsconf.yml` and `local.nsconf.yml` config files (all options are documented in these files)
4. run `nodestack init-project`
5. in `app/config` folder, setup `config.cson` and `.env` files
6. in `app/index.coffee` edit the object passed to the init function (this is documented in [knapp](https://www.npmjs.com/package/knapp))

Now your project is all setup. You only need to work with `routes.coffee` and whatever libs you create should go into `app/lib` folder.

Recommended project filesystem structure

```
|——app
   |——config
      |——.env
      |——config.cson
   |——lib
      |——lib.js
   |——log
   |——node_modules
   |——index.coffee
   |——package.json
   |——routes.coffee
|——doc
|——.gitignore
|——local.nsconf.yml
|——nsconf.yml
|——supervisor_conf
```

`.gitignore` is setup to exclude `app/config/.env` (among other things)

`nsconf.yml` and `local.nsconf.yml` config files need to be in the project root

`app` contains the API

# Develop your API

[knapp](https://www.npmjs.com/package/knapp) documentation explains creating routes, setting their meta (inSchema, outSchema and testRequest) and working with requests.

# Run API

Run command `nodestack runs`. This will setup and start/restart NGINX and start node server container. It will run on foregroung and it will output URLs for API and DOC. Sample:

```
NS running, links:
DOC: http://localhost:8080/ns/template-project/doc
API: http://localhost:8080/ns/template-project
```

# Stop API

Good old `CTRL+C` will do :)

# Run automated tests

Routes by default don't get included in automated tests. They get included when `testRequest` is defined in route meta object. `testRequest` contains data that will be sent to given endpoint in automated tests. It should honor the inputSchema, if it doesn't a "schema integrity error" will be thrown.

To run automated tests use command `nodestack atest`

# Generate documententation

Run `nodestack gendoc`

# Adding Node modules

If you just want to run `npm install` then use `nodestack npmi`

If you want to install specific module (`npm install --save MODULE_NAME`) then use `nodestack npmi MODULE_NAME`

# Use JavaScript

To compile coffee files in `app` folder use `nodestack gcompile`

# Deploy to remote

## Prerequisites

- SSH access to remote
- gzip (local machine)
- gunzip (remote)
- supervisor (remote)
- docker permissions for your SSH user (remote)
- supervisor permissions for your SSH user (remote)

`gzip` and `gunzip` are used to pack / unpack docker image which is uploaded to remote during deploy (if necessary).

## Prepare

In order for deploy to remote server, you need to setup a block under `remotes` block in projects `nsconf.yml` file. A sample `dev` block is included in template `nsconf.yml` file for every project. All the values are described there. You can have as many remote blocks as you wish.

You should go through deploy setup with NS maintainer, who will provide you with all information.

## Deploy

After you have everything set up, you can deploy to this remote with `nodestack deploy REMOTENAME`.

# Use s3 secrets commands

`nodestack s3s_` commands use [ansible role](./ansible/roles/s3-secrets). You can use them to easily manage AWS if you choose to store your secrets in S3.

All s3s commands require that you either specify `aws_credentials_path` with your command or use `--default-aws-credentials|-dac`. Examples:

`aws_credentials_path=/path/to/your/credentials/file uname=YOUR_USER_NAME nodestack s3s_cu`

or

`uname=YOUR_USER_NAME nodestack s3s_cu --default-aws-credentials`

or

`uname=YOUR_USER_NAME nodestack s3s_cu -dac`

Notice `uname` parameter used in those samples. All s3s commands require some parameters, complete list is:

* `s3s_cu` - uname
* `s3s_cuak` - uname
* `s3s_cb` - bname, region
* `s3s_ugba` - uname, bname
* `s3s_full` - uname, bname, region

If you don't specify these required variables the command will fail with message about missing required variable.

# Pull existing nodestack project

Run `nodestack pull REPOSITORY_URL`. This will:

* pull a repository
* `npm install` dependencies
* create necessary folders
* copy template Gruntfile

# Update node-stack

To update NS files from repository run `$NODESTACK_PATH/update`. This will NOT update your `.env` file, so if there are changes you need to apply them manually.  
