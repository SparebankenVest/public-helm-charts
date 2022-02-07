{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.version" -}}
{{- if .Values.image.tag -}}
{{ .Values.image.tag }}
{{- else -}}
{{ .Chart.Version }}
{{- end -}}
{{- end -}}

{{- define "common.utils.joinwithspace" -}}
{{- $space := " " }}
{{- $local := dict "first" true -}}
{{- range $k, $v := . -}}{{- if not $local.first -}}{{ $space }}{{- end -}}{{- $v -}}{{- $_ := set $local "first" false -}}{{- end -}}
{{- end -}}

{{/*
common.labels prints the default common labels.
The common labels are frequently used in metadata.
*/}}
{{- define "common.labels" -}}
app: "{{ template "common.name" . }}"
version: "{{ template "common.version" . }}"
part-of: rpm
app.kubernetes.io/name: "{{ template "common.name" . }}"
app.kubernetes.io/version: "{{ template "common.version" . }}"
app.kubernetes.io/part-of: rpm
{{- end -}}
