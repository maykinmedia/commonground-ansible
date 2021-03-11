Template out an NGINX configuration for a Django app
====================================================

Django apps should be frontend by a reverse proxy like NGINX. This role has a default
virtual host config template for these kind of apps, while still being configurable.

Features:

* Fully parametrized with sane defaults
* Namespaced per app
* Uses default values from `django_app_docker` role where possible

Works well with `django_app_docker` and `nginxinc.nginx` role.

Requirements
------------

None.

Role Variables
--------------

See `defaults/main.yml` for all available variables with their default values and
functionality.

**General variables**

* `django_app_nginx_prefix`: prefix used for namespacing purposes. The upstream for the
  `proxy_pass` will be called this. Defaults to `django_app_docker_name_prefix` if
  available, otherwise set to `app`. You should specify this when deploying multiple
  apps on the same host.

* `django_app_nginx_domain`: server name to listen for. Defaults to
  `django_app_docker_domain` when set.

* `django_app_nginx_upstream_replicas`: available backends for the upstream. Defaults to
  `_django_app_docker_replicas`, which is set as part of the `django_app_docker` role.

  Format:

  ```yaml
  django_app_nginx_upstream_replicas:
    - name: app-0
      port: 8000
  ```

**SSL related variables**

* `django_app_nginx_ssl`: whether to enable SSL or not, defaults to
  `django_app_docker_https` if set, otherwise defaults to `true`. If set, a virtualhost
  redirecting from http to https is configured, if not, only a virtualhost listening on
  port 80 is configured.

* `django_app_nginx_letsencrypt_enabled`: whether Let's Encrypt is used for certificates
  or not. This simplifies determining the certificate and private key locations. Set to
  `true` if `django_app_nginx_ssl` is enabled _and_ `cerbot_certs` is defined (from the
  `geerlingguy.certbot` role).

* `django_app_nginx_ssl_certificate` and `django_app_nginx_ssl_key`: paths to the SSL key
  and certificate. Specify these if not using Let's Encrypt, they're automatically
  derived otherwise.

* `django_app_nginx_generate_dhparam`: whether to generate Diffie-Helman parameters with
  4096 bits or not. On modern OS versions this is no longer required. Defaults to `false`.

* `django_app_nginx_ssl_protocols`: which SSL protocols to use. Defauls to TLS 1.2 and
  1.3. Note that 1.3 is only from Debian Buster and newer.

* `django_app_nginx_ssl_ciphers` which ciphersuite to use. Defaults to a secure, modern
  setup.

* `django_app_nginx_ssl_prefer_server_ciphers`: defaults to `off`. On modern
  installations, this is no longer required to be `on`.

* `django_app_nginx_ssl_hsts`: defaults to `max-age=63072000`. Enables
  Strict-Transport-Security.

**Miscellaneous**

* `django_app_nginx_cache`: whether to enable caching on the NGINX level. Defaults to
  `false`.

* `django_app_nginx_extra_directives`: any extra one-liner directives, for example to
  add a CSP-header. Defaults to `['client_max_body_size 1M']`

* `django_app_nginx_include_templates`: specify any template names/paths to include in
  the `server` block. Defaults to `[]`. Use this if you need to add extra
  `location /foo {...}` blocks, for example.

Dependencies
------------

None.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- hosts: app-servers

  collections:
    - maykinmedia.commonground

  vars:
    django_app_docker_name_prefix: example
    django_app_docker_domain: &domain example.example.com

    certbot_create_if_missing: true
    cerbot_certs:
      - domains:
        - *domain

    django_app_nginx_extra_directives:
      - 'client_max_body_size 4G'

    django_app_nginx_include_templates:
      - 'templates/private_media.conf.j2'

  roles:
     - role: geerlingguy.certbot

     - role: django_app_docker
     - role: django_app_nginx

     - role: nginxinc.nginx
       vars:
         nginx_http_template_enable: true
         nginx_http_template:
           default:
             # set by django_app_nginx role
             template_file: "{{ django_app_nginx_template }}"
             conf_file_name: "{{ django_app_nginx_prefix }}.conf"
             conf_file_location: /etc/nginx/conf.d/
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
