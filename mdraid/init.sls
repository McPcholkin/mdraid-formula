{% set os_type_check = salt['grains.get']('os_family') %}

include:
  - mdraid.install
  - mdraid.config
  {% if os_type_check == 'Debian' %}
  - mdraid.fixboot
  {% endif %}

