{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "azure-key-vault-to-kubernetes.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "azure-key-vault-to-kubernetes.fullname" -}}
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
Create the name of the service account to use
*/}}
{{- define "azure-key-vault-to-kubernetes.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{ default (include "azure-key-vault-to-kubernetes.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
{{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "azure-key-vault-to-kubernetes.useAuthService" -}}
{{- if and (.Values.keyVault.customAuth.enabled) (not .Values.keyVault.customAuth.useAuthService) -}}
{{ default "false" }}
{{- else -}}
{{ default "true" }}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "azure-key-vault-to-kubernetes.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "azure-key-vault-to-kubernetes.selfSignedIssuer" -}}
{{ printf "%s-selfsign" (include "azure-key-vault-to-kubernetes.fullname" .) }}
{{- end -}}

{{- define "azure-key-vault-to-kubernetes.rootCAIssuer" -}}
{{ printf "%s-ca" (include "azure-key-vault-to-kubernetes.fullname" .) }}
{{- end -}}

{{- define "azure-key-vault-to-kubernetes.rootCACertificate" -}}
{{ printf "%s-ca" (include "azure-key-vault-to-kubernetes.fullname" .) }}
{{- end -}}

{{- define "azure-key-vault-to-kubernetes.servingCertificate" -}}
{{ printf "%s-webhook-tls" (include "azure-key-vault-to-kubernetes.fullname" .) }}
{{- end -}}