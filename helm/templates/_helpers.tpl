{{/* Nom court du chart */}}
{{- define "mini-platform-app.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Nom complet (release-name + chart-name) */}}
{{- define "mini-platform-app.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/* Nom + version, utilisé dans un label */}}
{{- define "mini-platform-app.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/* Labels communs à toutes les ressources */}}
{{- define "mini-platform-app.labels" -}}
helm.sh/chart: {{ include "mini-platform-app.chart" . }}
{{ include "mini-platform-app.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/* Labels du selector (Deployment & Service partagent les mêmes) */}}
{{- define "mini-platform-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "mini-platform-app.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}
