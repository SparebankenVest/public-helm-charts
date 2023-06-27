# akv2k8s Helm Chart (Helm 3)

A Helm chart that deploys akv2k8s Controller and Env-Injector to Kubernetes

![Version: 2.4.0](https://img.shields.io/badge/Version-2.4.0-informational?style=flat-square) ![AppVersion: 1.4.0](https://img.shields.io/badge/AppVersion-1.4.0-informational?style=flat-square)

This chart will install:
  * a Controller for syncing AKV secrets to Kubernetes secrets
  * a Env-Injector enabling transparent environment injection of AKV secrets into container programs

For more information and installation instructions see the official documentation at https://akv2k8s.io

## Helm Chart and akv2k8s Versions

| Helm Chart                         | Controller | Env Injector | CA Bundle Controller | Env Injector Sidecar |
| ---------------------------------- | ---------- | ------------ | -------------------- | -------------------- |
| `2.4.0` | `1.4.0`    | `1.4.0`      | `removed`            | `1.4.0`              |
| `2.0.11`                           | `1.2.3`    | `1.2.3`      | `removed`            | `1.2.2`              |
| `2.0.0`                            | `1.2.0`    | `1.2.0`      | `removed`            | `1.2.0`              |
| `1.1.28`                           | `1.1.0`    | `1.1.0`      | `1.1.0`              | `1.1.1`              |

## Installation

To install the latest stable chart with the release name `akv2k8s`:

```bash
helm repo add spv-charts http://charts.spvapi.no
helm install akv2k8s spv-charts/akv2k8s
```

For the latest version:

```bash
helm repo add spv-charts http://charts.spvapi.no
helm install akv2k8s spv-charts/akv2k8s --version 2.4.0
```

## The AzureKeyVaultSecret CRD

Helm 3 doesn't upgrade CRDs, it only adds on the first install.

To ensure correct version of the AzureKeyVaultSecret CRD when upgrading, apply the CRD manually using the following command:

```bash
kubectl apply -f https://raw.githubusercontent.com/SparebankenVest/azure-key-vault-to-kubernetes/master/crds/AzureKeyVaultSecret.yaml
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| name | string | `"akv2k8s"` | Name of Helm installation |
| global.env | object | `{}` | Env vars to be used with all enabled pods, eg. for akv credentials |
| global.envFromSecret | list | `[]` | Reference to secret containing variables to be used with all enabled pods, eg. for akv credentials |
| global.logLevel | string | `"info"` | Sets klog log level info=2, debug=4, trace=6 |
| global.logFormat | string | `"text"` | Sets klog log format text or json |
| global.keyVaultAuth | string | `"azureCloudConfig"` | azureCloudConfig (aks credentials) or environment (custom) |
| global.userDefinedMSI.enabled | bool | `false` | Enable usage of user-defined MSI for AKV authentication (for running pods as non-root) |
| global.userDefinedMSI.msi | string | `nil` | User-defined MSI object ID for AKV Authentication |
| global.userDefinedMSI.subscriptionId | string | `nil` | Azure subscription ID where the user-defined MSI for AKV Authentication resides |
| global.userDefinedMSI.tenantId | string | `nil` | Azure tenant ID where the user-defined MSI for AKV Authentication resides |
| global.userDefinedMSI.azureCloudType | string | `nil` | Azure cloud type (usually AzurePublicCloud) |
| global.metrics.enabled | bool | `false` | Enable prometheus metrics |
| global.metrics.serviceMonitor.enabled | bool | `false` | Enable service-monitor |
| global.metrics.serviceMonitor.interval | string | `"30s"` | Scrape interval for service-monitor |
| global.metrics.serviceMonitor.additionalLabels | object | `{}` | Additional labels for service-monitor |
| global.rbac.create | bool | `true` | Specifies whether RBAC resources should be created |
| global.rbac.podSecurityPolicies | object | `{}` |  |
| addAzurePodIdentityException | bool | `false` | See https://github.com/Azure/aad-pod-identity/blob/master/docs/readmes/README.app-exception.md |
| cloudConfig | string | `"/etc/kubernetes/azure.json"` | Path to cloud config on node (host path) or mounted configmap in pod |
| watchAllNamespaces | bool | `true` | Watch all namespaces, set to false to run in release namespace only |
| azureKeyVaultResyncPeriod | int | `30` | Resync periods for the controller in seconds |
| kubeResyncPeriod | int | `30` | Resync periods for the controller in seconds |
| controller.name | string | `"controller"` | Name |
| controller.enabled | bool | `true` | Whether to install the controller |
| controller.image.repository | string | `"spvest/azure-keyvault-controller"` | Image repository that contains the controller image |
| controller.image.tag | string | `"1.4.0"` | Image tag |
| controller.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for controller |
| controller.logLevel | string | `nil` | Override global log level info=2, debug=4, trace=6 |
| controller.logFormat | string | `nil` | Override global log format text or json |
| controller.keyVaultAuth | string | `nil` | Override global - azureCloudConfig (aks credentials), environment (custom) |
| controller.serviceAccount.create | bool | `true` | Create service account for controller |
| controller.serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| controller.serviceAccount.annotations | object | `{}` | Controller service account annotations |
| controller.serviceAccount.labels | object | `{}` | Controller service account labels |
| controller.rbac | object | `{"create":null}` | Override global.rbac to create the controller rbac only |
| controller.rbac.create | bool | `nil` | Override global.rbac.create |
| controller.podSecurityContext | string | `nil` | Security context set on a pod level |
| controller.priorityClassName | string | `""` | Controller PriorityClass name |
| controller.securityContext.allowPrivilegeEscalation | bool | `true` | Must be `true` if using aks identity - can be set to false if userDefinedMSI is enabled, or Azure AD Pod Identity is used |
| controller.service.type | string | `"ClusterIP"` |  |
| controller.service.externalHttpPort | int | `9000` | External metrics port |
| controller.service.internalHttpPort | int | `9000` | Internal metrics port (set to larger than 1024 when running without privileges) |
| controller.metrics.enabled | bool | `nil` | Override global.metrics.enabled |
| controller.metrics.serviceMonitor.enabled | bool | `nil` | Override global.metrics.serviceMonitor.enabled |
| controller.metrics.serviceMonitor.interval | string | `nil` | Override global.metrics.serviceMonitor.interval |
| controller.metrics.serviceMonitor.additionalLabels | object | `nil` | Override global.metrics.serviceMonitor.additionalLabels |
| controller.env | object | `{}` | Controller envs |
| controller.envFromSecret | list | `[]` | Reference to secret containing variables to be used with all enabled pods, eg. for akv credentials |
| controller.labels | object | `{}` | Controller labels |
| controller.podLabels | object | `{}` | Controller pod labels |
| controller.podAnnotations | object | `{}` | Controller pod annotations |
| controller.strategy.rollingUpdate | object | `{"maxSurge":"25%","maxUnavailable":"25%"}` | Controller rolling update strategy settings |
| controller.resources | object | `{}` | Controller resources |
| controller.nodeSelector | object | `{}` | Node selector for controller |
| controller.tolerations | list | `[]` | Tolerations for controller |
| controller.affinity | object | `{}` | Affinities for controller |
| controller.extraVolumeMounts | list | `[]` | Additional volumeMounts to the controller main container |
| controller.extraVolumes | list | `[]` | Additional volumes to the controller pod |
| env_injector.enabled | bool | `true` | Whether to install the env-injector |
| env_injector.name | string | `"env-injector"` | Name |
| env_injector.keyVaultAuth | string | `nil` | Override global - azureCloudConfig (aks credentials) or environment (custom) |
| env_injector.authService | bool | `true` | Set to false to provide azure key vault credentials locally (through e.g. env vars) in each pod |
| env_injector.image.repository | string | `"spvest/azure-keyvault-webhook"` | Image repository that contains the env-injector image |
| env_injector.image.tag | string | `"1.4.0"` | Image tag |
| env_injector.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for env-injector |
| env_injector.replicaCount | int | `2` | Number of env-injector replicas |
| env_injector.envImage.repository | string | `"spvest/azure-keyvault-env"` | Image repository that contains the vaultenv image |
| env_injector.envImage.tag | string | `"1.4.0"` | Image tag |
| env_injector.envImage.pullPolicy | string | `"IfNotPresent"` | Image pull policy for vaultenv |
| env_injector.logLevel | string | `nil` | Override global log level info=2, debug=4, trace=6 |
| env_injector.logFormat | string | `nil` | Override global log format text or json |
| env_injector.certificate.useCertManager | bool | `false` | Use cert-manager to handle webhook certificates, if `false` and `env_injector.webhook.certificate.custom.enabled=false` certificates and CA is generated by Helm |
| env_injector.certificate.custom.enabled | bool | `false` | Use custom cert to handle webhook certificates, if `false` and `env_injector.webhook.certificate.useCertManager=false` certificates and CA is generated by Helm. |
| env_injector.certificate.custom.server.tls.crt | string | `nil` | Custom TLS certificate, required when `env_injector.certificate.custom.enabled=true` |
| env_injector.certificate.custom.server.tls.key | string | `nil` | Custom TLS key, required when `env_injector.certificate.custom.enabled=true` |
| env_injector.certificate.custom.ca.crt | string | `nil` | Custom CA certificate, required when `env_injector.certificate.custom.enabled=true` |
| env_injector.podSecurityContext | string | `nil` | Security context set on a pod level |
| env_injector.securityContext.allowPrivilegeEscalation | bool | `true` | Must be `true` if using aks identity - can be set to false if userDefinedMSI is enabled, or Azure AD Pod Identity is used |
| env_injector.namespaceLabelSelector.label.name | string | `"azure-key-vault-env-injection"` | Webhook will only trigger i namespaces with this label |
| env_injector.namespaceLabelSelector.label.value | string | `"enabled"` | Whether the namespace selector is enabled |
| env_injector.dockerImageInspection.timeout | int | `20` | Timeout in seconds |
| env_injector.service.type | string | `"ClusterIP"` |  |
| env_injector.service.externalTlsPort | int | `443` | External webhook and health tls port |
| env_injector.service.internalTlsPort | int | `8443` | Internal webhook and health tls port (set to larger than 1024 when running without privileges) |
| env_injector.service.externalHttpPort | int | `80` | External metrics and health port |
| env_injector.service.internalHttpPort | int | `8080` | Internal metrics and health port (set to larger than 1024 when running without privileges) |
| env_injector.service.externalMtlsPort | int | `9443` | External auth service mtls port |
| env_injector.service.internalMtlsPort | int | `9443` | Internal auth service mtls port (set to larger than 1024 when running without privileges) |
| env_injector.metrics.enabled | bool | `nil` | Override global.metrics.enabled |
| env_injector.metrics.serviceMonitor.enabled | bool | `nil` | Override global.metrics.serviceMonitor.enabled |
| env_injector.metrics.serviceMonitor.interval | string | `nil` | Override global.metrics.serviceMonitor.interval |
| env_injector.metrics.serviceMonitor.additionalLabels | object | `nil` | Override global.metrics.serviceMonitor.additionalLabels |
| env_injector.serviceAccount.create | bool | `true` | Create service account for env-injector |
| env_injector.serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| env_injector.serviceAccount.annotations | object | `{}` | env-injector service account annotations |
| env_injector.serviceAccount.labels | object | `{}` | env-injector service account labels |
| env_injector.rbac | object | `{"create":null}` | Override global.rbac to create the env_injector rbac only |
| env_injector.rbac.create | bool | `nil` | Override global.rbac.create |
| env_injector.env | object | `{}` | Additional env vars to send to env-injector pods |
| env_injector.envFromSecret | list | `[]` | Reference to secret containing variables to be used with all enabled pods, eg. for akv credentials |
| env_injector.labels | object | `{}` | Additional labels |
| env_injector.podLabels | object | `{}` | Additional pod labels |
| env_injector.podAnnotations | object | `{}` | Additional pod annotations |
| env_injector.podDisruptionBudget.enabled | bool | `true` | Enable pod disruption budget |
| env_injector.podDisruptionBudget.minAvailable | int | `1` | Min available pods at any time |
| env_injector.podDisruptionBudget.maxUnavailable | string | `nil` | Max unavailable pods at any time |
| env_injector.strategy.rollingUpdate | object | `{"maxSurge":"25%","maxUnavailable":"25%"}` | Environment Injector rolling update strategy settings |
| env_injector.failurePolicy | string | `"Fail"` | What will happen if the webhook fails? Ignore (continue) or Fail (prevent Pod from starting)? |
| env_injector.namespaceSelector.matchExpressions[0] | object | `{"key":"name","operator":"NotIn","values":["kube-system"]}` | Ignore kube-system namespace |
| env_injector.resources | object | `{}` | Resources for env injector |
| env_injector.nodeSelector | object | `{}` | Node selector |
| env_injector.tolerations | list | `[]` | Tolerations |
| env_injector.affinity | object | `{}` | Affinities |
| env_injector.extraVolumeMounts | list | `[]` | Additional volumeMounts to the env-injector main container |
| env_injector.extraVolumes | list | `[]` | Additional volumes to the env-injector pod |
| env_injector.rbacSubjects[0] | object | `{"apiGroup":"rbac.authorization.k8s.io","kind":"Group","name":"system:serviceaccounts"}` | Include Group or ServiceAccount |
