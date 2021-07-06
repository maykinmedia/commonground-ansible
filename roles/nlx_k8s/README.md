Deploy an NLX stack on a Kubernetes cluster
===========================================

Deploying NLX inway, outway, management UI on a cluster.

Requirements
------------

* Access to the K8s cluster and the relevant namespace
* `kubectl` commandline tool should be installed on your local machine (Ansible control
  node) to validate/debug deployments
* PostgreSQL (or other relevant database engine) must be installed and configured for
  transaction logging.

This role plays well with:

* `geerlingguy.postgresql` for DB provisioning

Role Variables
--------------

See `defaults/main.yml` for all available variables with their default values and
functionality.

Dependencies
------------

* `community.k8s` collection to manage k8s infrastructure

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

[default-project]: https://bitbucket.org/maykinmedia/default-project
