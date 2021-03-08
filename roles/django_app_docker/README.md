Deploy a Django-app with Docker
===============================

Deploy a Django app conforming to [default-project][default-project] as Docker containers.

Maykin Media's default project is suitable for publishing the application as Docker
image. This role provides the tooling to deploy this app on a VM with Docker.

Features:

* Fully parametrized with sane defaults
* App-namespace - deploy multiple apps on the same host
* Stateless or stateful apps
* Support for nginx virtual host entry
* Celery support (worker, beat, multiple queues, flower)

Requirements
------------

* Root access (or any other user privileged to manage Docker infra)
* Docker must be installed and configured on the target machine
* PostgreSQL (or other relevant database engine) must be installed and configured on
  the target machine

This role plays well with:

* `geerlingguy.postgresql` for DB provisioning
* `geerlingguy.docker` for Docker runtime installation
* `geerlingguy.certbot` for Let's Encrypt integration
* `nginxinc.nginx` for NGINX installation and configuration
* `openzaak.deploy` collection for base system provisioning

Role Variables
--------------

See `defaults/main.yml` for all available variables with their default values and
functionality.

The variables below are best specified explicitly or changed because the defaults
lead to an insecure deployment:

* `django_app_docker_name_prefix` - used to namespace each application.
* `django_app_docker_domain` - domain where the app is deployed
* `django_app_docker_secret_key` - generate one using
  https://miniwebtool.com/django-secret-key-generator/ and keep it secret
* `django_app_docker_sentry_dsn` - highly recommended to create a Sentry project for
  error monitoring.
* `django_app_docker_package_name` - python package name of the app, if different from
  the name prefix.

Database credentials:

* `django_app_docker_db_name` - name of the database to connect to
* `django_app_docker_db_user` - user to use for db connection
* `django_app_docker_db_password` - password to use for db connection

The default variables assume that a databse is running on the same host system, with
`/var/run/postgresql` holding the unix sockets.

Container image:

* `django_app_docker_version` - point to a pinned image tag. Avoid using `latest`,
  unless you want to _always_ pull container images while deploying.
* `django_app_docker_sha256` - better alternative for pinned image versions, as digests
  are immutable while image tags are not.
* `django_app_docker_image_name` - image name in the format `maykinmedia/<name>` for the
  app. Defaults to `maykinmedia/<prefix>`.

Host machine interface:

* `django_app_docker_replicas` - number of backend containers to run (web). Increasing
  this number consumes more resources but allows you to handle more concurrent requests.
* `django_app_docker_port_start` - ports published from Docker to the host. Make sure
  these ports are available. Defaults to `8000`.

Celery integration

* `django_app_docker_flower_user` and `django_app_docker_flower_password` are sensitive
  credentials, giving insight into the application internals and possibly data as task
  arguments.

Dependencies
------------

* `community.docker` collection to manage Docker infrastructure

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: username.rolename, x: 42 }

License
-------

UNLICENSED

Author Information
------------------

[Maykin Media](https://www.maykinmedia.nl/en/) provides hassle-free, custom-made
websites and webapps for clients.

We pride ourselves in solid, well-tested applications and contributing back to the Open
Source community. We provide consultancy, development and support & hosting.

[default-project]: https://bitbucket.org/maykinmedia/default-project
