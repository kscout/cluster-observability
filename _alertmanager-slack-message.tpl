{{ range .Alerts }}
*Alert*: {{ .Annotations.title }}
*Description*: {{ .Annotations.description }}
*Maintainers*: {{ .Labels.maintainers }}
*Severity*: {{ .Labels.severity }}
{{ end }}
