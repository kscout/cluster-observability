# Cluster Observability
Prometheus configuration for kscout.io OpenShift cluster.

# Table Of Contents
- [Overview](#overview)
- [Deploy](#deploy)

# Overview
Deployment for Prometheus operator.

# Deploy
Set the `ALERTMANAGER_SLACK_WEBHOOK` environment variable to the alert manager's
Slack web hook.

Deploy Alert Manager:

```
./resources/alertmanager-config.yaml.sh | oc apply -f -
oc apply -f resources/alertmanager-server.yaml
```

Deploy Prometheus:

```
oc apply -f resources/prometheus-server.yaml
```
