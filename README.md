# Cluster Observability
Prometheus + Alert Manager configuration for kscout.io OpenShift cluster.

# Table Of Contents
- [Overview](#overview)
- [Deploy](#deploy)

# Overview
Deployment for Prometheus + Alert Manager observability stack.

# Deploy
1. Make a copy of `values.secrets.example.yaml` named 
   `values.secrets.prod.yaml`. Never commit this file!
2. Edit `values.secrets.prod.yaml` with your own values
3. Run:
   ```
   make deploy-prod
   ```
