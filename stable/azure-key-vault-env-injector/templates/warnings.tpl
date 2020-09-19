{{/* this file is for generating warnings about incorrect usage of the chart */}}

{{- if .Values.certificate.generate  }}
{{- if .Values.certificate.useCertManager }}
    {{ fail "It is not allowed to both set webhook.certificate.generate=true and webhook.certificate.useCertManager=true."}}
{{- end }}
{{- end }}
