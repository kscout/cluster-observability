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
cat resources/alertmanager-server.yaml | \
    sed "s/ALERTMANAGER_SLACK_WEBHOOK/$ALERTMANAGER_SLACK_WEBHOOK" | \
	oc apply -f -
```

Deploy Prometheus:

```
oc apply -f resources/prometheus-server.yaml
```
