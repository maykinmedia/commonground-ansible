Deploy a Django app with Kubernetes
===================================

Deploy a Django app conforming to [default-project][default-project] as Kubernetes
workload.

Maykin Media's default project is suitable for publishing the application as Docker
image. This role provides the tooling to deploy this app in a Kubernetes namespace.

Features:

* Fully parametrized with sane defaults
* Stateless or stateful apps
* Persistent volume claims support
* Celery support (worker, beat, multiple queues, flower)

[default-project]: https://bitbucket.org/maykinmedia/default-project

Requirements
------------

* `KUBECONFIG` file to talk to the Kubernetes API server
* Python packages on the controller:

  ```
  openshift
  kubernetes-validate
  ```
* PostgreSQL (or other relevant database server) available

Role Variables
--------------

See `defaults/main.yml` for all available variables with their default values and
functionality.

Dependencies
------------

* `community.kubernetes` collection to manage Kubernetes objects

Example Playbook
----------------

TODO

License
-------

UNLICENSED

Author Information
------------------

[Maykin Media](https://www.maykinmedia.nl/en/) provides hassle-free, custom-made
websites and webapps for clients.

We pride ourselves in solid, well-tested applications and contributing back to the Open
Source community. We provide consultancy, development and support & hosting.
