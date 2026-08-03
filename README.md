# monitor-environment

Full observability and monitoring stack deployed via Docker Compose. Collects system metrics, logs, container stats, and endpoint health checks with dashboards and alerting.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/bi0punk/monitor-environment/actions/workflows/ci.yml/badge.svg)](https://github.com/bi0punk/monitor-environment/actions/workflows/ci.yml)

## Tabla de Contenidos

- [Características](#características)
- [Stack](#stack)
- [Arquitectura](#arquitectura)
- [Requisitos](#requisitos)
- [Instalación](#instalación)
- [Uso](#uso)
- [Tests](#tests)
- [Configuración](#configuración)
- [CI](#ci)
- [Limitaciones / Roadmap](#limitaciones--roadmap)
- [Licencia](#licencia)

## Características

- Métricas de host con Node Exporter y cAdvisor
- Dashboards auto-aprovisionados en Grafana
- Agregación de logs con Loki + Promtail
- Alertas configurables con Alertmanager
- Health checks de endpoints con Blackbox Exporter
- Stack completamente orquestado con Docker Compose

## Stack

Docker Compose, Prometheus, Grafana, Loki, Promtail, Alertmanager, cAdvisor, Node Exporter, Blackbox Exporter

## Arquitectura

```
monitor-environment/
├── prometheus/
│   └── prometheus.yml
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       └── dashboards/
├── loki/
│   └── loki-config.yaml
├── promtail/
│   └── promtail-config.yaml
├── alertmanager/
│   └── alertmanager.yml
├── docker-compose.yml
├── init.sh
├── tests/
├── .env.example
└── README.md
```

## Servicios

| Servicio         | Puerto | Descripción                |
|------------------|--------|----------------------------|
| Prometheus       | 9090   | Métricas                   |
| Grafana          | 3000   | Dashboards                 |
| Loki             | 3100   | Logs                       |
| Promtail         | —      | Log shipping               |
| Alertmanager     | 9093   | Alertas                    |
| cAdvisor         | 8080   | Métricas de contenedores   |
| Node Exporter    | 9100   | Métricas del host          |
| Blackbox Exporter| 9115   | Health checks              |

## Requisitos

- Docker Engine 24+
- Docker Compose v2

## Instalación

```bash
git clone https://github.com/bi0punk/monitor-environment.git
cd monitor-environment
bash init.sh
```

## Uso

```bash
# Inicializar archivos de configuración por defecto
bash init.sh

# Iniciar toda la pila
docker compose up -d

# Ver logs
docker compose logs -f

# Detener
docker compose down
```

Acceder a Grafana en `http://localhost:3000` (admin / strong-admin-pass) con dashboards pre-configurados.

## Tests

```bash
docker compose config  # validar sintaxis de compose
pip install pytest ruff && pytest -q  # tests unitarios (si existen)
```

## Configuración

Variables de entorno (ver `.env.example`):

| Variable             | Default           | Descripción                     |
|----------------------|-------------------|---------------------------------|
| `GF_ADMIN_PASSWORD`  | `strong-admin-pass` | Password admin de Grafana     |

## CI

GitHub Actions ejecuta validación de sintaxis y lint en cada push y PR.

## Limitaciones / Roadmap

- [ ] Auto-descubrimiento de servicios via Docker labels
- [ ] Alertas por Slack/Email pre-configuradas
- [ ] Exportación de dashboards como JSON
- [ ] TLS/SSL para servicios expuestos

## Licencia

MIT
