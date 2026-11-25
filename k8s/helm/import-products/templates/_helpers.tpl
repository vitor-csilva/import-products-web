{{/*
Expand the name of the chart.
*/}}
{{- define "import-products.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "import-products.fullname" -}}
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

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "import-products.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels (no component — set per resource)
*/}}
{{- define "import-products.labels" -}}
helm.sh/chart: {{ include "import-products.chart" . }}
app.kubernetes.io/name: {{ include "import-products.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Immutable matchLabels for Deployment/Service.
Keep stable: changing these requires deleting the Deployment.
Matches the selector applied by chart 7.0.0.
*/}}
{{- define "import-products.selectorLabels" -}}
app: {{ include "import-products.fullname" . }}
app.kubernetes.io/name: {{ include "import-products.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: app
{{- end }}

{{/*
Pod template labels (must include selectorLabels)
*/}}
{{- define "import-products.podLabels" -}}
{{ include "import-products.selectorLabels" . }}
{{- end }}

{{/*
Database fullname
*/}}
{{- define "import-products.database.fullname" -}}
{{- printf "db-%s" (include "import-products.fullname" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Immutable matchLabels for StatefulSet/Service DB.
After the one-time StatefulSet delete, these stay stable.
*/}}
{{- define "import-products.database.selectorLabels" -}}
app: {{ include "import-products.database.fullname" . }}
app.kubernetes.io/name: {{ include "import-products.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: database
{{- end }}

{{/*
Database pod template labels
*/}}
{{- define "import-products.database.podLabels" -}}
{{ include "import-products.database.selectorLabels" . }}
{{- end }}

{{/*
Database host (service DNS)
*/}}
{{- define "import-products.database.host" -}}
{{- if .Values.database.host -}}
{{- .Values.database.host -}}
{{- else -}}
{{- include "import-products.database.fullname" . -}}
{{- end -}}
{{- end }}

{{/*
Secret name for DB credentials
*/}}
{{- define "import-products.secretName" -}}
{{- if .Values.database.existingSecret -}}
{{- .Values.database.existingSecret -}}
{{- else -}}
{{- printf "%s-credentials" (include "import-products.fullname" .) -}}
{{- end -}}
{{- end }}

{{/*
API URL used by the frontend
*/}}
{{- define "import-products.apiUrl" -}}
{{- if .Values.app.apiUrl -}}
{{- .Values.app.apiUrl -}}
{{- else if and .Values.gateway.enabled .Values.gateway.hostnames -}}
{{- printf "https://%s/api/" (index .Values.gateway.hostnames 0) -}}
{{- else -}}
{{- printf "http://%s/api/" (include "import-products.fullname" .) -}}
{{- end -}}
{{- end }}

{{/*
Service account name
*/}}
{{- define "import-products.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
{{- default (printf "%s-cronjob" (include "import-products.fullname" .)) .Values.serviceAccount.name -}}
{{- else -}}
{{- default "default" .Values.serviceAccount.name -}}
{{- end -}}
{{- end }}

{{/*
Readiness probe port
*/}}
{{- define "import-products.readinessPort" -}}
{{- if .Values.probes.readiness.port -}}
{{- .Values.probes.readiness.port -}}
{{- else -}}
{{- .Values.service.backend.targetPort -}}
{{- end -}}
{{- end }}
