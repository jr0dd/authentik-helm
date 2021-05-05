{{- define "authentik.ingress.isStable" -}}
  {{- $isStable := "" -}}
  {{- if eq (include "common.capabilities.ingress.apiVersion" $) "networking.k8s.io/v1" -}}
    {{- $isStable = "true" -}}
  {{- end -}}
  {{- $isStable -}}
{{- end -}}

{{- define "authentik.env" -}}
  {{- range $k, $v := . -}}
    {{- if kindIs "map" $v -}}
      {{- range $sk, $sv := $v -}}
        {{- include "authentik.env" (dict (printf "%s__%s" (upper $k) (upper $sk)) $sv) -}}
      {{- end -}}
    {{- else -}}
      {{- $value := $v -}}
      {{- if or (kindIs "bool" $v) (kindIs "float64" $v) -}}
        {{- $v = quote $v -}}
      {{- end -}}
      {{- if $v }}
- name: {{ printf "AUTHENTIK_%s" (upper $k) }}
  value: {{ $v }}
      {{- end }}
    {{- end -}}
  {{- end -}}
{{- end -}}