{{ range .Alerts }}
*Alert*: {{ .Annotations.title }}
*Host*: [{{ .Annotations.host }}]]({{ .Annotations.host }})
*Description*: {{ .Annotations.description }}
*Maintainers*: {{ .Labels.maintainers }}
*Severity*: {{ .Labels.severity }}

{{- if .Labels }}
*Labels*:
{{- for $key, $value := range .Labels }}
    - *{{ $key }}*: `{{ $value }}`
{{- end }}
{{- end }}
{{ end }}
