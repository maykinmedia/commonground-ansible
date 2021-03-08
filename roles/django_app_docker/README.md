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

TODO

Dependencies
------------

None.

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

[default-project][https://bitbucket.org/maykinmedia/default-project]
