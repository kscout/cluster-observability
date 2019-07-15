{{ range .Alerts }}
*Alert*: {{ .Annotations.title }}
*Host*: [{{ .Annotations.host }}]]({{ .Annotations.host }})
*Description*: {{ .Annotations.description }}
*Maintainers*: {{ .Labels.maintainers }}
*Severity*: {{ .Labels.severity }}
{{ end }}
