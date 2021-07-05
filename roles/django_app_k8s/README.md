Deploy a Django-app on a k8 cluster
===============================

This role can be used to deploy API components on a kubernetes cluster.

Features:

* Fully parametrized with sane defaults
* App-namespace - deploy multiple apps on the same host
* Stateless or stateful apps
* Support for nginx virtual host entry
* Celery support (worker, beat, multiple queues, flower)

Requirements
------------

* Access to the k8 cluster and the relevant namespace
* Kubectl commandline tool must be installed on your local machine (Ansible control node)
* PostgreSQL (or other relevant database engine) must be installed and configured 

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

* `django_app_k8s_name_prefix` - used to namespace each application.
* `django_app_k8s_domain` - domain where the app is deployed
* `django_app_k8s_secret_key` - generate one using
  https://miniwebtool.com/django-secret-key-generator/ and keep it secret
* `django_app_k8s_sentry_dsn` - highly recommended to create a Sentry project for
  error monitoring.
* `django_app_k8s_package_name` - python package name of the app, if different from
  the name prefix.
* `django_app_k8s_tls` - indicates whether or not TLS should be configured for the application (currently only supports TLS with a single certificate). Requires the following variables to be defined:
    * `django_app_k8s_tls_cert` - the certificate to be used for TLS
    * `django_app_k8s_tls_key` - the private key to be used for TLS
Database credentials:

* `django_app_k8s_db_name` - name of the database to connect to
* `django_app_k8s_db_user` - user to use for db connection
* `django_app_k8s_db_password` - password to use for db connection

The default variables assume that a database is running on the same host system, with
`/var/run/postgresql` holding the unix sockets.

Container image:

* `django_app_k8s_version` - point to a pinned image tag. Avoid using `latest`,
  unless you want to _always_ pull container images while deploying.
* `django_app_k8s_sha256` - better alternative for pinned image versions, as digests
  are immutable while image tags are not. 
* `django_app_k8s_image_name` - image name in the format `maykinmedia/<name>` for the
  app. Defaults to `maykinmedia/<prefix>`.

Host machine interface:

* `django_app_k8s_replicas` - number of backend containers to run (web). Increasing
  this number consumes more resources but allows you to handle more concurrent requests.
* `django_app_k8s_port_start` - ports published from k8s to the host. Make sure
  these ports are available. Defaults to `8000`.

Celery integration

* `django_app_k8s_flower_user` and `django_app_k8s_flower_password` are sensitive
  credentials, giving insight into the application internals and possibly data as task
  arguments.

**Facts set**

This role sets some facts that can be used in subsequent roles:

* `django_app_k8s_image` the resolved image 'name'. Combines image registry, image name
  and tag/sha256.

* `_django_app_k8s_replicas`: a list of replicas, derived from the number of desired
  replicas and starting port. You can use this to define nginx upstreams, for example:

  ```yaml
  - name: <prefix>-0
    port: 8000
  - name: <prefix>-1
    port: 8001
  - name: <prefix>-2
    port: 8002
  ```

Dependencies
------------

* `community.k8s` collection to manage k8s infrastructure

Example Playbook
----------------

**Standard backend deploy - Django only**

```yaml
- name: Simple Django playbook
  hosts: all

  collections:
    - maykinmedia.commonground

  vars:
    django_app_k8s_name_prefix: example1
    django_app_k8s_domain: example1.example.com
    django_app_k8s_secret_key: '*chbr!n^(s9(13(9j3kkodb4-ptn36)2q-a&2u!c6!tu)^53vr'
    django_app_k8s_package_name: example1
    django_app_k8s_db_name: example1
    django_app_k8s_db_username: example1
    django_app_k8s_db_password: example1
    django_app_k8s_version: latest
    django_app_k8s_image_name: scrumteamzgw/bptl
    django_app_k8s_replicas: 1
    django_app_k8s_port_start: 8000

  roles:
    - role: django_app_k8s
```

**Celery enabled deploy - Django backend + celery**

```yaml
- name: Django playbook with Celery, Beat and Flower
  hosts: all

  collections:
    - maykinmedia.commonground

  vars:
    django_app_k8s_name_prefix: example2
    django_app_k8s_domain: example2.maykinmedia.nl
    django_app_k8s_secret_key: '*chbr!n^(s9(13(9j3kkodb4-ptn36)2q-a&2u!c6!tu)^53vr'
    django_app_k8s_package_name: example2
    django_app_k8s_db_name: example2
    django_app_k8s_db_username: example2
    django_app_k8s_db_password: example2
    django_app_k8s_version: latest
    django_app_k8s_image_name: scrumteamzgw/bptl
    django_app_k8s_replicas: 1
    django_app_k8s_port_start: 13000

    django_app_k8s_use_celery: true
    django_app_k8s_use_celery_beat: true
    django_app_k8s_use_flower: true
    django_app_k8s_flower_port: 13555

  roles:
    - role: django_app_k8s
```

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
