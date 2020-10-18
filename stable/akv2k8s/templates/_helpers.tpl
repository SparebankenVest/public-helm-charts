{{/* vim: set filetype=mustache: */}}

{{/*
The akv2k8s name
*/}}
{{- define "akv2k8s.name" -}}
{{- default .Values.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The controller name
*/}}
{{- define "akv2k8s.controller.name" -}}
{{- default .Values.controller.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
The env-injector name
*/}}
{{- define "akv2k8s.envinjector.name" -}}
{{- default .Values.env_injector.name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the Helm install
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "akv2k8s.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the controller.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "akv2k8s.controller.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-%s" .Values.fullnameOverride "controller" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name "controller" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name "controller" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name for the env-injector.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "akv2k8s.envinjector.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- printf "%s-%s" .Values.fullnameOverride "envinjector" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- printf "%s-%s" .Release.Name "envinjector" | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s-%s" .Release.Name $name "envinjector" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "controller.serviceAccountName" -}}
{{- if .Values.controller.serviceAccount.create -}}
{{ default (include "akv2k8s.controller.fullname" .) .Values.controller.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.controller.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "envinjector.serviceAccountName" -}}
{{- if .Values.env_injector.serviceAccount.create -}}
{{ default (include "akv2k8s.envinjector.fullname" .) .Values.env_injector.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.env_injector.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "envinjector.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "akv2k8s.envinjector.fullname" .) }}
{{- end -}}

{{- define "envinjector.rootCAIssuer" -}}
{{ printf "%s-ca" (include "akv2k8s.envinjector.fullname" .) }}
{{- end -}}

{{- define "envinjector.rootCACertificate" -}}
{{ printf "%s-ca" (include "akv2k8s.envinjector.fullname" .) }}
{{- end -}}

{{- define "envinjector.servingCertificate" -}}
{{- if .Values.env_injector.certificate.useCertManager -}}
{{ printf "%s-webhook-tls-cm" (include "akv2k8s.envinjector.fullname" .) }}
{{- else -}}
{{ printf "%s-webhook-tls" (include "akv2k8s.envinjector.fullname" .) }}
{{- end -}}
{{- end -}}

{{- define "envinjector.namespaceSelector" -}}
{{ printf "%s: %s" .Values.env_injector.namespaceLabelSelector.label.name .Values.env_injector.namespaceLabelSelector.label.value }}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "akv2k8s.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common EnvInjector selectors.
*/}}
{{- define "akv2k8s.selectors" -}}
app.kubernetes.io/name: {{ template "akv2k8s.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/*
Common EnvInjector labels.
*/}}
{{- define "akv2k8s.labels" -}}
{{- include "akv2k8s.selectors" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ template "akv2k8s.chart" . }}
{{- end -}}

{{/*
EnvInjector webhook component
*/}}
{{- define "akv2k8s.components.webhook" -}}
app.kubernetes.io/component: {{ template "akv2k8s.fullname" . }}-webhook
{{- end -}}

{{/*
Controller component
*/}}
{{- define "akv2k8s.components.controller" -}}
app.kubernetes.io/component: {{ template "akv2k8s.fullname" . }}-controller
{{- end -}}
