# monitor-environment

Stack completo de observabilidad y monitoreo desplegado con Docker Compose. Recopila métricas del sistema, logs, estadísticas de contenedores y health checks de endpoints, con dashboards y alertas.

[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![CI](https://github.com/bi0punk/monitor-environment/actions/workflows/ci.yml/badge.svg)](https://github.com/bi0punk/monitor-environment/actions/workflows/ci.yml)

## Contenido

- [Características](#características)
- [Arquitectura](#arquitectura)
- [Stack](#stack)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Instalación](#instalación)
- [Uso](#uso)
- [Configuración](#configuración)
- [Tests / CI](#tests--ci)
- [Roadmap](#roadmap)
- [Licencia](#licencia)

## Características

- Métricas de host con Node Exporter y cAdvisor.
- Dashboards auto-aprovisionados en Grafana.
- Agregación de logs con Loki + Promtail.
- Alertas configurables con Alertmanager.
- Health checks de endpoints con Blackbox Exporter.
- Stack completamente orquestado con Docker Compose.

## Arquitectura

```mermaid
flowchart TD
    NODE[Node Exporter<br/>:9100 - métricas del host] -->|scrape| PROM[Prometheus<br/>:9091 host / :9090 cont]
    CAD[cAdvisor<br/>:8080 - métricas de contenedores] -->|scrape| PROM
    BLACK[Blackbox Exporter<br/>:9115 - health checks] -->|scrape| PROM
    LOGS[/var/log] -->|push| PROMTAIL[Promtail<br/>:9080]
    PROMTAIL -->|logs| LOKI[Loki<br/>:3100]
    PROM -->|alertas| ALERT[Alertmanager<br/>:9093]
    PROM -->|datasource| GRAF[Grafana<br/>:3000]
    LOKI -->|datasource| GRAF
    ALERT -->|receiver null/email| OUT[notificaciones]
```

## Stack

| Servicio | Puerto (host) | Descripción |
|----------|---------------|-------------|
| Prometheus | 9091 | Métricas (contenedor: 9090) |
| Grafana | 3000 | Dashboards |
| Loki | 3100 | Logs |
| Promtail | — | Log shipping |
| Alertmanager | 9093 | Alertas |
| cAdvisor | 8080 | Métricas de contenedores |
| Node Exporter | 9100 | Métricas del host |
| Blackbox Exporter | 9115 | Health checks |

## Estructura del repositorio

```
monitor-environment/
├── prometheus/
│   └── prometheus.yml
├── grafana/
│   └── provisioning/
│       ├── datasources/datasource.yml
│       └── dashboards/dashboard.yml
├── loki/
│   └── loki-config.yaml
├── promtail/
│   └── promtail-config.yaml
├── alertmanager/
│   └── alertmanager.yml
├── docker-compose.yml
├── init.sh
├── tests/test_smoke.py
├── .env.example
└── LICENSE
```

## Instalación

Requisitos: Docker Engine 24+ y Docker Compose v2.

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

Acceder a Grafana en `http://localhost:3000` con el password definido en `GF_ADMIN_PASSWORD` (ver Configuración), con dashboards y datasources pre-configurados.

## Configuración

Variables de entorno (ver `.env.example`):

| Variable             | Default             | Descripción                    |
|----------------------|---------------------|--------------------------------|
| `GF_ADMIN_PASSWORD`  | (obligatoria)       | Password admin de Grafana (`:?` exige que esté definida) |

El script `init.sh` genera los archivos de configuración por defecto: `prometheus.yml`, `grafana/provisioning/*`, `loki-config.yaml`, `promtail-config.yaml` y `alertmanager.yml`.

## Tests / CI

```bash
docker compose config  # validar sintaxis de compose
pip install pytest ruff && pytest -q  # tests unitarios
```

CI — GitHub Actions (`.github/workflows/ci.yml`) sobre Python 3.11 con `uv`, en cada push y PR:

- `ruff check .`.
- `pytest -q`.

## Roadmap

- [ ] Auto-descubrimiento de servicios via Docker labels.
- [ ] Alertas por Slack/Email pre-configuradas.
- [ ] Exportación de dashboards como JSON.
- [ ] TLS/SSL para servicios expuestos.

## Licencia

MIT — ver [LICENSE](LICENSE).