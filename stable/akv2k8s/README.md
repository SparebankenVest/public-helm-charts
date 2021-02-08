# akv2k8s Helm Chart (Helm 3)

A Helm chart that deploys akv2k8s Controller and Env-Injector to Kubernetes

![Version: 1.1.29-beta.2](https://img.shields.io/badge/Version-1.1.29--beta.2-informational?style=flat-square) ![AppVersion: 1.1.0](https://img.shields.io/badge/AppVersion-1.1.0-informational?style=flat-square)

This chart will install:
  * a Controller for syncing AKV secrets to Kubernetes secrets
  * a Env-Injector enabling transparent environment injection of AKV secrets into container programs

For more information and installation instructions see the official documentation at https://akv2k8s.io

## The AzureKeyVaultSecret CRD

Helm 3 doesn't upgrade the CRD, only applies on the first install.

To ensure correct version of the AzureKeyVaultSecret CRD when upgrading, run the following command:

```
kubectl apply -f https://raw.githubusercontent.com/sparebankenvest/azure-key-vault-to-kubernetes/crd-1.1.0/crds/AzureKeyVaultSecret.yaml
```

To install the latest stable chart with the release name `akv2k8s`:

```
helm repo add spv-charts http://charts.spvapi.no
helm install akv2k8s spv-charts/akv2k8s
```

For the latest release:

```
helm repo add spv-charts http://charts.spvapi.no
helm install akv2k8s spv-charts/akv2k8s --version 1.1.29-beta.2
```

## Configuration

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| global.env | object | `{}` | Env vars to be used with all enabled pods, eg. for akv credentials |
| rbac.create | bool | `true` | Specifies whether RBAC resources should be created |
| rbac.podSecurityPolicies | object | `{}` |  |
| runningInsideAzureAks | bool | `true` | If running inside azure aks - set to false if running outside aks |
| addAzurePodIdentityException | bool | `false` | Add Azure Pod Identity Exception |
| cloudConfig | string | `"/etc/kubernetes/azure.json"` | Path to cloud config on node (host path) |
| controller.enabled | bool | `true` | If controller will be installed |
| controller.name | string | `"controller"` |  |
| controller.image.repository | string | `"spvest/azure-keyvault-controller"` | Image repository that contains the controller image |
| controller.image.tag | string | `"1.1.0"` | Image tag |
| controller.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for controller |
| controller.keyVault.customAuth.enabled | bool | `false` | Set to true to use custom auth - see https://akv2k8s.io/security/authentication/#custom-authentication-for-the-controller |
| controller.keyVault.polling.normalInterval | string | `"1m"` | Interval to wait before polling azure key vault for secret updates |
| controller.keyVault.polling.failureInterval | string | `"10m"` | Interval to wait when polling has failed `failureAttempts` before polling azure key vault for secret updates |
| controller.keyVault.polling.failureAttempts | int | `5` | Number of times to allow secret updates to fail before applying `failureInterval` |
| controller.logLevel | string | `"info"` | Controller log level |
| controller.logFormat | string | `"fmt"` | Controller log format fmt or json |
| controller.serviceAccount.create | bool | `true` | Create service account for controller |
| controller.serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| controller.env | object | `{}` | Controller envs |
| controller.labels | object | `{}` | Controller labels |
| controller.podLabels | object | `{}` | Controller pod labels |
| controller.resources | object | `{}` | Controller resources |
| controller.nodeSelector | object | `{}` | Node selector for controller |
| controller.tolerations | list | `[]` | Tolerations for controller |
| controller.affinity | object | `{}` | Affinities for controller |
| env_injector.enabled | bool | `true` | If the env-injector will be installed |
| env_injector.name | string | `"env-injector"` |  |
| env_injector.replicaCount | int | `2` | Number of env-injector replicas |
| env_injector.image.repository | string | `"spvest/azure-keyvault-webhook"` | Image repository that contains the env-injector image |
| env_injector.image.tag | string | `"1.1.10"` | Image tag |
| env_injector.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for env-injector |
| env_injector.envImage.repository | string | `"spvest/azure-keyvault-env"` | Image repository that contains the env image |
| env_injector.envImage.tag | string | `"1.1.1"` | Image tag |
| env_injector.keyVault.customAuth.enabled | bool | `false` | Set to true to use custom auth - see https://github.com/SparebankenVest/azure-key-vault-to-kubernetes/blob/master/README.md#authentication |
| env_injector.keyVault.customAuth.useAuthService | bool | `true` | Set to false to use Azure Key Vault credentials from own pod |
| env_injector.dockerImageInspection.timeout | int | `20` | Timeout in seconds |
| env_injector.dockerImageInspection.useAksCredentialsWithACS | bool | `true` | Only applicable if `runningInsideAzureAks` is also `true` |
| env_injector.caBundleController.image.repository | string | `"spvest/ca-bundle-controller"` | Image repository that contains the ca-bundle image |
| env_injector.caBundleController.image.tag | string | `"1.1.0"` | Image tag |
| env_injector.caBundleController.image.pullPolicy | string | `"IfNotPresent"` | Image pull policy for ca bundler |
| env_injector.caBundleController.env | object | `{}` | Additional env vars to add to the ca-bundle pod |
| env_injector.caBundleController.labels | object | `{}` | Additional labels |
| env_injector.caBundleController.podLabels | object | `{}` | Additional pod labels |
| env_injector.caBundleController.logLevel | string | `"Info"` | Log level ca-bundle pod |
| env_injector.caBundleController.logFormat | string | `"fmt"` | fmt or json |
| env_injector.caBundleController.akvLabelName | string | `"azure-key-vault-env-injection"` | AKV label used in namespaces for injection |
| env_injector.caBundleController.configMapName | string | `"akv2k8s-ca"` | Configmap name to store ca cert |
| env_injector.caBundleController.resources | object | `{}` | Resources for ca-bundle pod |
| env_injector.service.name | string | `"azure-keyvault-secrets-webhook"` | Webhook service name |
| env_injector.service.type | string | `"ClusterIP"` |  |
| env_injector.service.externalTlsPort | int | `443` | External webhook and health tls port |
| env_injector.service.internalTlsPort | int | `8443` | Internal webhook and health tls port (set to larger than 1024 when running without privileges) |
| env_injector.service.externalHttpPort | int | `80` | External metrics and health port |
| env_injector.service.internalHttpPort | int | `8080` | Internal metrics and health port (set to larger than 1024 when running without privileges) |
| env_injector.service.externalAuthServiceMutualTlsPort | int | `9443` | External auth service mtls port |
| env_injector.service.internalAuthServiceMutualTlsPort | int | `9443` | Internal auth service mtls port (set to larger than 1024 when running without privileges) |
| env_injector.metrics.enabled | bool | `false` | Enable prometheus metrics for env-injector |
| env_injector.metrics.serviceMonitor.enabled | bool | `false` | Enable service-monitor for env-injector |
| env_injector.metrics.serviceMonitor.interval | string | `"30s"` | Scrape interval for service-monitor |
| env_injector.metrics.serviceMonitor.additionalLabels | object | `{}` | Additional labels for service-monitor |
| env_injector.webhook.logLevel | string | `"Info"` | Webhook log level |
| env_injector.webhook.logFormat | string | `"fmt"` | ftm or json |
| env_injector.webhook.securityContext.allowPrivilegeEscalation | bool | `true` | must be true if using aks identity |
| env_injector.webhook.env | object | `{}` | Additional env vars to send to webhook pod |
| env_injector.webhook.labels | object | `{}` | Additional labels |
| env_injector.webhook.podLabels | object | `{}` | Additional pods labels |
| env_injector.webhook.certificate.useCertManager | bool | `false` | Use cert-manager to handle webhook certificates, if `false` and `env_injector.webhook.certificate.custom.enabled=false` certificates and CA is generated by Helm |
| env_injector.webhook.certificate.custom.enabled | bool | `false` | Use custom cert to handle webhook certificates, if `false` and `env_injector.webhook.certificate.useCertManager=false` certificates and CA is generated by Helm. |
| env_injector.webhook.certificate.custom.server.tls.crt | string | `nil` | Custom TLS certificate, required when `env_injector.webhook.certificate.custom.enabled=true` |
| env_injector.webhook.certificate.custom.server.tls.key | string | `nil` | Custom TLS key, required when `env_injector.webhook.certificate.custom.enabled=true` |
| env_injector.webhook.certificate.custom.ca.crt | string | `nil` | Custom CA certificate, required when `env_injector.webhook.certificate.custom.enabled=true` |
| env_injector.webhook.podDisruptionBudget | object | `{"enabled":true,"minAvailable":1}` | See `kubectl explain poddisruptionbudget.spec` for more ref: https://kubernetes.io/docs/tasks/run-application/configure-pdb/ |
| env_injector.webhook.failurePolicy | string | `"Fail"` | What will happen if the webhook fails? Ignore (continue) or Fail (prevent Pod from starting)? |
| env_injector.webhook.namespaceSelector | object | `{"matchExpressions":[{"key":"name","operator":"NotIn","values":["kube-system"]}],"matchLabels":{"azure-key-vault-env-injection":"enabled"}}` | https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#matching-requests-namespaceselector |
| env_injector.webhook.namespaceSelector.matchLabels.azure-key-vault-env-injection | string | `"enabled"` | The webhook will only trigger i namespaces with this label |
| env_injector.webhook.namespaceSelector.matchExpressions[0] | object | `{"key":"name","operator":"NotIn","values":["kube-system"]}` | Prevent env injection for pods in kube-system as recomended: https://kubernetes.io/docs/reference/access-authn-authz/extensible-admission-controllers/#avoiding-operating-on-the-kube-system-namespace |
| env_injector.serviceAccount.create | bool | `true` | Create service account for env-injector |
| env_injector.serviceAccount.name | string | `nil` | The name of the ServiceAccount to use. If not set and create is true, a name is generated using the fullname template |
| env_injector.resources | object | `{}` | Resources for env injector |
| env_injector.nodeSelector | object | `{}` | Node selector for env injector and ca-bundle |
| env_injector.tolerations | list | `[]` | Tolerations for env injector and ca-bundle |
| env_injector.affinity | object | `{}` | Affinities for env injector and ca-bundle |
