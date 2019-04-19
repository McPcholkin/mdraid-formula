{%- from "mdraid/map.jinja" import map with context -%}

include:
  - mdraid.install

{% set raids = salt['pillar.get']('mdraid:raids', False) %}

{#
test:
  file.managed:
    - name: /tmp/pillar.test
    - context: {{ raids }}
    #}

{% if raids %}
{% for raid in raids %}
{% set absent = salt['pillar.get']('mdraid:raids:'~raid~':absent', False) %}
{% set name = salt['pillar.get']('mdraid:raids:'~raid~':name', False) %}
{% set level = salt['pillar.get']('mdraid:raids:'~raid~':level', '1') %}
{% set chunk = salt['pillar.get']('mdraid:raids:'~raid~':chunk', False) %}
{% set run = salt['pillar.get']('mdraid:raids:'~raid~':run', True) %}
{% set devices = salt['pillar.get']('mdraid:raids:'~raid~':devices', False) %}

{% if absent %}
delete_raid_{{ raid }}:
  raid.absent:
    - name: {{ name }}
    - require:
      - pkg: install_mdadm
{% else %}
create_raid_{{ raid }}:
  raid.present:
    - name: {{ name }}
    - level: {{ level }}
    - devices: {{ devices }}
    {% if chunk %}
    - chunk: {{ chunk }}
    {% endif %}
    - run: {{ run }}
    - require:
      - pkg: install_mdadm
{% endif %}

{% endfor %}
{% endif %}
