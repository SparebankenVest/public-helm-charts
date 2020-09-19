{{/* this file is for generating warnings about incorrect usage of the chart */}}

{{- if .Values.webhook.certificate.generate  }}
{{- if .Values.webhook.certificate.useCertManager }}
    {{ fail "It is not allowed to both set webhook.certificate.generate=true and webhook.certificate.useCertManager=true."}}
{{- end }}
{{- end }}
