{%- from "mdraid/map.jinja" import map with context -%}

install_mdadm:
  pkg.installed:
    - name: {{ map.pkg }}


