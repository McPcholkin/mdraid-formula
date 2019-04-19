{%- from "mdraid/map.jinja" import map with context -%}
{% set raids_fix = salt['pillar.get']('mdraid:raids', False) %}
{#  fix boot degradeted array on debian #}

degradetad_array_boot_fix:
  file.managed:
    - name: /etc/initramfs-tools/scripts/init-premount/assemble-md0
    - user: root
    - group: root
    - mode: 755
    - contents:
      {% if raids_fix %}
      {% for raid_fix in raids_fix %}
      {% set raid_name_fix = salt['pillar.get']('mdraid:raids:'~raid_fix~':name', False) %}
      - 'mdadm -S {{ raid_name_fix }}'
      {% endfor %}
      {% else %}
      - 'mdadm -S /dev/md0'
      {% endif %}
      - 'mdadm -A --scan'


update_initramfs:
  cmd.run:
    - name: update-initramfs -u
    - require:
      - file: degradetad_array_boot_fix
    - watch:
      - file: /etc/initramfs-tools/scripts/init-premount/assemble-md0
