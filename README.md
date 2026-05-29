# monitor-environment

Full observability and monitoring stack deployed via Docker Compose. Collects system metrics, logs, container stats, and endpoint health checks with dashboards and alerting.

## Stack

Docker Compose, Prometheus, Grafana, Loki, Promtail, Alertmanager, cAdvisor, Node Exporter, Blackbox Exporter

## Services

| Service | Port | Description |
|---|---|---|
| Prometheus | 9090 | Metrics collection |
| Grafana | 3000 | Dashboards (auto-provisioned) |
| Loki | 3100 | Log aggregation |
| Promtail | — | Log shipping |
| Alertmanager | 9093 | Alert management |
| cAdvisor | 8080 | Container metrics |
| Node Exporter | 9100 | Host metrics |
| Blackbox Exporter | 9115 | Endpoint probing |

## Usage

```bash
# Initialize config files
bash init.sh

# Start the stack
docker compose up -d
```

## License

MIT
