---
title: "akv2k8s Helm Chart (Helm 3)"
description: "Azure Key Vault to Kubernetes Helm reference"
---

This chart will install:
  * a Custom Resource Definition (`AzureKeyVaultSecret`)
  * a Controller for syncing AKV secrets to Kubernetes secrets
  * a Env-Injector enabling transparent environment injection of AKV secrets into container programs

For more information and installation instructions see the official documentation at https://akv2k8s.io

## Configuration

### General

|               Parameter                           |                Description                   |                  Default                 |
| ------------------------------------------------- | -------------------------------------------- | -----------------------------------------|
| crds.enabled                                      | if this chart should manage the azurekeyvaultsecret crd     | true |
| crds.create                                       | if this chart should create the azurekeyvaultsecret crd | true |
| crds.keep                                         | if this chart should keep azurekeyvaultsecret crd after uninstalling the chart - note: if set to false, all azurekeyvaultsecret resources created in the cluster will automatically be removed when the crd gets removed | true | 
| rbac.create                                       | create rbac resources|true|
| rbac.podSecurityPolicies                          | any pod security policies|{}|


### Controller

|               Parameter                           |                Description                   |                  Default                 |
| ------------------------------------------------- | -------------------------------------------- | -----------------------------------------|
|controller.env                                     |aditional env vars to send to pod             | []                                       |
|controller.image.repository                        |image repo that contains the controller image | spvest/azure-keyvault-controller         |
|controller.image.tag                               |image tag                                     |1.0.2|
|controller.image.pullPolicy                        |pull policy                                   | IfNotPresent |
|controller.keyVault.customAuth                     |if custom auth is enabled                     | false |
|controller.keyVault.customAuth.podIdentitySelector |if using aad-pod-identity, which selector to reference | "" |
|controller.keyVault.polling.normalInterval         |interval to wait before polling azure key vault for secret updates | 1m |
|controller.keyVault.polling.failureInterval        |interval to wait when polling has failed `failureAttempts` before polling azure key vault for secret updates | 5m |
|controller.keyVault.polling.failureAttempts        |number of times to allow secret updates to fail before applying `failureInterval` | 5 |
|controller.logLevel                                |log level | info |
|controller.labels                                  |any additional labels | []
|controller.podLabels                               |any additional labels | []

### Env-Injector

|               Parameter                        |                Description                  |                  Default                 |
| ---------------------------------------------- | ------------------------------------------- | -----------------------------------------|
|env_injector.affinity                                        |affinities to use                            |{}                                        |
|env_injector.authService.enabled                             |if authservice is used for central akv authentication|true|
|env_injector.authService.caBundleController.image.repository |image repository for ca bundler|spvest/ca-bundle-controller|
|env_injector.authService.caBundleController.image.tag        |image tag for ca bundler|1.1.0-beta.24|
|env_injector.authService.caBundleController.image.pullPolicy |pull policy for ca bundler|IfNotPresent|
|env_injector.authService.caBundleController.logLevel         |log level - Trace, Debug, Info, Warning, Error, Fatal or Panic|Info|
|env_injector.authService.caBundleController.akvLabelName     |akv label used in namespaces|azure-key-vault-env-injection|
|env_injector.authService.caBundleController.configMapName    |configmap name to store ca cert|akv2k8s-ca|
|env_injector.cloudConfigHostPath                             |path to azure cloud config                   |/etc/kubernetes/azure.json                |
|env_injector.env                                             |aditional env vars to send to pod            |{}                                        |
|env_injector.envImage.repository                             |image repo that contains the env image       |spvest/azure-keyvault-env                 |
|env_injector.envImage.tag                                    |image tag                                    |1.0.2                                    |
|env_injector.image.pullPolicy                                |image pull policy                            |IfNotPresent                              |
|env_injector.image.repository                                |image repo that contains the controller      |spvest/azure-keyvault-webhook             |
|env_injector.image.tag                                       |image tag                                    |1.0.2                                    |
|env_injector.keyVault.customAuth                             |if custom authentication with azure key vault is enabled |false                         |
|env_injector.metrics.enabled                                 |if prometheus metrics is enabled             |false                                     |
|env_injector.nodeSelector                                    |node selector to use                         |{}                                        |
|env_injector.replicaCount                                    |number of replicas                           |1                                         |
|env_injector.resources                                       |resources to request                         |{}                                        |
|env_injector.service.name                                    |webhook service name                         |azure-keyvault-secrets-webhook            |
|env_injector.service.type                                    |webhook service type                         |ClusterIP                                 |
|env_injector.service.externalTlsPort                         |service tls port                     |443           |
|env_injector.service.internalTlsPort                         |pod tls port                         |443               |
|env_injector.service.externalHttpPort                        |service http port for metrics and healthz|443           |
|env_injector.service.internalHttpPort                        |pod http port for metrics and healthz|443               |
|env_injector.tolerations                                     |tolerations to add                           |[]                                        |
|env_injector.webhook.logLevel                                |log level - Trace, Debug, Info, Warning, Error, Fatal or Panic | Info                   |
|env_injector.webhook.dockerImageInspectionTimeout            |max time to inspect docker image and find exec cmd|20 sec|
|env_injector.webhook.failurePolicy                           |  |Ignore|
|env_injector.webhook.podDisruptionBudget.enabled             |if pod disruption budget is enabled          |true                                      |
|env_injector.webhook.podDisruptionBudget.minAvailable        |pod disruption minimum available             |1                                         |
|env_injector.webhook.podDisruptionBudget.maxUnavailable      |pod disruption maximum unavailable           |nil                                       |
|env_injector.labels                                          |any additional labels | []
|env_injector.podLabels                                       |any additional labels | []
