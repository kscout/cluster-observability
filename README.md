# Cluster Observability
Prometheus + Alert Manager configuration for kscout.io OpenShift cluster.

# Table Of Contents
- [Overview](#overview)
- [Deploy](#deploy)
- [Add Service](#add-service)
- [Access](#access)

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
4. (Optional) If the deployment included a ConfigMap change run the appropriate
   make target for the service with the ConfigMap change:
   ```
   make restart-prometheus ENV=prod
   # Or
   make restart-alertmanager ENV=prod
   ```


# Add Service
To add a service to the observability stack add a value to the `services` list
in the [`values.yaml` file](values.yaml).  

See the comment explaining this array, and existing entries, for
more information.

This will trigger alerts when the service goes down.

# Access
To access deployed services first run:

```
make proxy
```

Then in another terminal run one of the following to open a service in 
your browser:

```
make open-prometheus 
# Or
make open-alertmanager
```

Replace `<env>` with an environment.
