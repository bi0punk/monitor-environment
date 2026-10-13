#!/bin/bash

# Crear directorios
mkdir -p grafana/provisioning/dashboards
mkdir -p grafana/provisioning/datasources
mkdir -p loki
mkdir -p prometheus
mkdir -p promtail
mkdir -p alertmanager

# Crear archivos y agregar contenido
cat <<EOL > grafana/provisioning/dashboards/dashboard.yml
apiVersion: 1

providers:
  - name: 'default'
    orgId: 1
    folder: ''
    type: file
    options:
      path: /etc/grafana/provisioning/dashboards
EOL

cat <<EOL > grafana/provisioning/datasources/datasource.yml
apiVersion: 1

datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: 'http://prometheus:9090'
    isDefault: true
  - name: Loki
    type: loki
    access: proxy
    url: 'http://loki:3100'
EOL

cat <<EOL > loki/loki-config.yaml
server:
  http_listen_port: 3100
  grpc_listen_port: 9096

ingester:
  wal:
    enabled: true
    dir: /loki/wal

  chunk_target_size: 1048576
  max_chunk_age: 1h

  storage_config:
    boltdb_shipper:
      active_index_directory: /loki/index
      cache_location: /loki/cache
    filesystem:
      directory: /loki/chunks
EOL

cat <<EOL > prometheus/prometheus.yml
global:
  scrape_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'loki'
    static_configs:
      - targets: ['loki:3100']

  - job_name: 'promtail'
    static_configs:
      - targets: ['promtail:9080']
EOL

cat <<EOL > promtail/promtail-config.yaml
server:
  http_listen_port: 9080

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: system
    static_configs:
      - targets:
          - localhost
        labels:
          job: varlogs
          __path__: /var/log/*log
EOL

cat <<EOL > alertmanager/alertmanager.yml
global:
  resolve_timeout: 5m

route:
  group_by: ['alertname']
  receiver: 'null'

receivers:
  - name: 'null'

  - name: 'email'
    email_configs:
      - to: 'youremail@example.com'
        from: 'alertmanager@example.com'
        smarthost: 'smtp.example.com:587'
        auth_username: 'your_username'
        auth_password: 'your_password'
EOL

echo "Estructura de directorios y archivos con configuración creada correctamente."
