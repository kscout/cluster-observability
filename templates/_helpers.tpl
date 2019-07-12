{{/*
Builds name of Prometheus metrics service.

Context should be a dict with the keys:

- env: .Values.global.env
- name: name field of .Values.services item

This dict can be constructed with the following code:

$_ := dict "env" $.Values.global.env "name" .name

Assuming the above is run with its context being one of the .Values.services items
*/}}
{{- define "cluster-observability.metrics-svc" -}}
{{ .env }}-{{ .name }}-metrics:9180
{{- end -}}

{{/*
Converts a lowercase dash seperated service name into a titlecase name.

Should be called with the context of an item from .Values.services.
*/}}
{{- define "cluster-observability.title-name" -}}
{{ .name | replace "-" " " | title | replace "Api" "API" }}
{{- end -}}
