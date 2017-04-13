{%- from "neutron/map.jinja" import server with context %}
{%- if underlay.get('enabled', False) %}

neutron_server_packages:
  pkg.installed:
  - names: {{ underlay.pkgs }}


/etc/neutron/neutron.conf:
  file.managed:
  - source: salt://neutron/files/underlay/neutron.conf.j2
  - template: jinja
  - require:
    - pkg: neutron_server_packages


/etc/neutron/dnsmasq.conf:
  file.managed:
  - source: salt://neutron/files/underlay/dnsmasq.conf.j2
  - template: jinja
  - require:
    - pkg: neutron_server_packages

{%- if not grains.get('noservices', False) %}

neutron_server_services:
  service.running:
  - names: {{ underlay.services }}
  - enable: true
  - watch:
    - file: /etc/neutron/neutron.conf
    - file: /etc/neutron/dnsmasq.conf

{%- endif %}


{%- endif %}
