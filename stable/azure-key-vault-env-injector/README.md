# Azure Key Vault Env-Injector Helm Chart

>**Deprecated - This Chart is deprecated in favor of the new [Helm 3 Chart](../akv2k8s).**

This chart will install the Azure Key Vault Env Injector as a mutating admission webhook, enabling transparent injection of Azure Key Vault secrets to applications running inside containers as environment variables.

For more information see the main GitHub repository at https://github.com/SparebankenVest/azure-key-vault-to-kubernetes.

## Installation

See the documentation for installation instructions: https://akv2k8s.io/installation/

## Not running akv2k8s inside Azure AKS?

The most common scenario when using Azure Key Vault with Kubernetes, is running inside Azure AKS. Because of this some features are enabled by default, which will not work outside of Azure AKS. To disable these, set `runningInsideAzureAks` to `false`. 

## Configuration

The following tables lists configurable parameters of the azure-key-vault-env-injector chart and their default values.

|               Parameter                        |                Description                  |                  Default                 |
| ---------------------------------------------- | ------------------------------------------- | -----------------------------------------|
|runningInsideAzureAks                           |if akv2k8s is running inside azure aks - set to false if running outside aks |true |
|affinity                                        |affinities to use                            |{}                                        |
|caBundleController.image.repository             |image repository for ca bundler|spvest/ca-bundle-controller|
|caBundleController.image.tag                    |image tag for ca bundler|1.1.0-beta.24|
|caBundleController.image.pullPolicy             |pull policy for ca bundler|IfNotPresent|
|caBundleController.logLevel                     |log level - Trace, Debug, Info, Warning, Error, Fatal or Panic|Info|
|caBundleController.logFormat                    |log format - fmt or json|fmt|
|caBundleController.akvLabelName                 |akv label used in namespaces|azure-key-vault-env-injection|
|caBundleController.configMapName                |configmap name to store ca cert|akv2k8s-ca|
|caBundleController.podLabels                    |Labels to add to the ca-bundle pod           |{} |
|cloudConfigHostPath                             |path to azure cloud config                   |/etc/kubernetes/azure.json                |
|dockerImageInspection.timeout                   |timeout in seconds                           |20                                        |
|dockerImageInspection.useAksCredentialsWithACS  |                                             |true|
|env                                             |aditional env vars to send to pod            |{}                                        |
|envImage.repository                             |image repo that contains the env image       |spvest/azure-keyvault-env                 |
|envImage.tag                                    |image tag                                    |1.0.2                                    |
|image.pullPolicy                                |image pull policy                            |IfNotPresent                              |
|image.repository                                |image repo that contains the controller      |spvest/azure-keyvault-webhook             |
|image.tag                                       |image tag                                    |1.0.2                                    |
|keyVault.customAuth.enabled                     |if custom authentication with azure key vault is enabled |false                         |
|metrics.enabled                                 |if prometheus metrics is enabled             |false                                     |
|nodeSelector                                    |node selector to use                         |{}                                        |
|replicaCount                                    |number of replicas                           |1                                         |
|resources                                       |resources to request                         |{}                                        |
|service.name                                    |webhook service name                         |azure-keyvault-secrets-webhook            |
|service.type                                    |webhook service type                         |ClusterIP                                 |
|service.externalTlsPort                         |service tls port                     |443           |
|service.internalTlsPort                         |pod tls port                         |443               |
|service.externalHttpPort                        |service http port for metrics and healthz|443           |
|service.internalHttpPort                        |pod http port for metrics and healthz|443               |
|tolerations                                     |tolerations to add                           |[]                                        |
|webhook.logLevel                                |log level - Trace, Debug, Info, Warning, Error, Fatal or Panic | Info                   |
|webhook.logFormat                               |log format - fmt or json | fmt                   |
|webhook.certificate.useCertManager              |use cert manager to handle webhook certificates| false|
|webhook.certificate.custom.enabled              |use custom certs for webhook|false|
|webhook.certificate.custom.server.tls.crt       |custom tls cert|""|
|webhook.certificate.custom.server.tls.key       |custom tls key|""|
|webhook.certificate.custom.ca.crt               |custom ca cert|""|
|webhook.failurePolicy                           |  |Ignore|
|webhook.podDisruptionBudget.enabled             |if pod disruption budget is enabled          |true                                      |
|webhook.podDisruptionBudget.minAvailable        |pod disruption minimum available             |1                                         |
|webhook.podDisruptionBudget.maxUnavailable      |pod disruption maximum unavailable           |nil                                       |
|webhook.podLabels                               |Labels to add to the webhook pod             |{} |
|serviceAccount.create                           |create service account?                      |true|
|serviceAccount.name                             |name of service account                      |generated|
