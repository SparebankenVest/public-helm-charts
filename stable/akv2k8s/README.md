# akv2k8s Helm Chart (Helm 3)

This chart will install:
  * a Controller for syncing AKV secrets to Kubernetes secrets
  * a Env-Injector enabling transparent environment injection of AKV secrets into container programs

For more information and installation instructions see the official documentation at https://akv2k8s.io

## The AzureKeyVaultSecret CRD

We have removed the CRD from the Helm Chart and this must be manually installed/updated prior to installing the chart:

```
kubectl apply -f https://raw.githubusercontent.com/sparebankenvest/azure-key-vault-to-kubernetes/crd-{{ version }}/crds/AzureKeyVaultSecret.yaml
```

To use the latest CRD, run:

```
kubectl apply -f https://raw.githubusercontent.com/sparebankenvest/azure-key-vault-to-kubernetes/crd-1.1.0/crds/AzureKeyVaultSecret.yaml
```

## Configuration

### General

|               Parameter                           |                Description                   |                  Default                 |
| ------------------------------------------------- | -------------------------------------------- | -----------------------------------------|
| rbac.create                                       | create rbac resources|true|
| rbac.podSecurityPolicies                          | any pod security policies|{}|
| runningInsideAzureAks                             | if running inside azure aks - set to false if running outside aks |true |


### Controller

|               Parameter                           |                Description                   |                  Default                 |
| ------------------------------------------------- | -------------------------------------------- | -----------------------------------------|
|controller.env                                     |aditional env vars to send to pod             | {}                                       |
|controller.image.repository                        |image repo that contains the controller image | spvest/azure-keyvault-controller         |
|controller.image.tag                               |image tag                                     |1.1.0|
|controller.image.pullPolicy                        |pull policy                                   | IfNotPresent |
|controller.keyVault.customAuth.enabled             |if custom auth is enabled                     | false |
|controller.keyVault.polling.normalInterval         |interval to wait before polling azure key vault for secret updates | 1m |
|controller.keyVault.polling.failureInterval        |interval to wait when polling has failed `failureAttempts` before polling azure key vault for secret updates | 5m |
|controller.keyVault.polling.failureAttempts        |number of times to allow secret updates to fail before applying `failureInterval` | 5 |
|controller.logFormat                               |log format - fmt or json | fmt                   |
|controller.logLevel                                |log level | info |
|controller.labels                                  |any additional labels | {}
|controller.podLabels                               |any additional labels | {}

### Env-Injector

|               Parameter                                     |                Description                  |                  Default                 |
| ----------------------------------------------------------- | ------------------------------------------- | -----------------------------------------|
|env_injector.affinity                                        |affinities to use                            |{}                                        |
|env_injector.caBundleController.akvLabelName                 |akv label used in namespaces|azure-key-vault-env-injection|
|env_injector.caBundleController.configMapName                |configmap name to store ca cert|akv2k8s-ca|
|env_injector.caBundleController.env                          |Env vars to add to the ca-bundle pod         |{} |
|env_injector.caBundleController.image.pullPolicy             |pull policy for ca bundler|IfNotPresent|
|env_injector.caBundleController.image.repository             |image repository for ca bundler|spvest/ca-bundle-controller|
|env_injector.caBundleController.image.tag                    |image tag for ca bundler                     |1.1.0|
|env_injector.caBundleController.labels                       |Labels to add to the ca-bundle deployment    |{} |
|env_injector.caBundleController.logLevel                     |log level - Trace, Debug, Info, Warning, Error, Fatal or Panic|Info|
|env_injector.caBundleController.logFormat                    |log format - fmt or json|fmt|
|env_injector.caBundleController.podLabels                    |Labels to add to the ca-bundle pod           |{} |
|env_injector.cloudConfigHostPath                             |path to azure cloud config                   |/etc/kubernetes/azure.json                |
|env_injector.dockerImageInspection.timeout                   |timeout in seconds                           |20                                        |
|env_injector.dockerImageInspection.useAksCredentialsWithACS  |                                             |true|
|env_injector.env                                             |aditional env vars to send to pod            |{}                                        |
|env_injector.envImage.repository                             |image repo that contains the env image       |spvest/azure-keyvault-env                 |
|env_injector.envImage.tag                                    |image tag                                    |1.1.0                                    |
|env_injector.image.pullPolicy                                |image pull policy                            |IfNotPresent                              |
|env_injector.image.repository                                |image repo that contains the controller      |spvest/azure-keyvault-webhook             |
|env_injector.image.tag                                       |image tag                                    |1.1.6                                    |
|env_injector.keyVault.customAuth.enabled                     |if custom authentication with azure key vault is enabled |false                         |
|env_injector.metrics.enabled                                 |if prometheus metrics is enabled             |false                                     |
|env_injector.name                                            ||env-injector|
|env_injector.nodeSelector                                    |node selector to use                         |{}                                        |
|env_injector.replicaCount                                    |number of replicas                           |2                                         |
|env_injector.resources                                       |resources to request                         |{}                                        |
|env_injector.service.name                                    |webhook service name                         |azure-keyvault-secrets-webhook            |
|env_injector.service.type                                    |webhook service type                         |ClusterIP                                 |
|env_injector.service.externalTlsPort                         |service tls port                     |443           |
|env_injector.service.internalTlsPort                         |pod tls port                         |443               |
|env_injector.service.externalHttpPort                        |service http port for metrics and healthz|443           |
|env_injector.service.internalHttpPort                        |pod http port for metrics and healthz|443               |
|env_injector.serviceAccount.create                           |create service account?                      |true|
|env_injector.serviceAccount.name                             |name of service account                      |generated|
|env_injector.tolerations                                     |tolerations to add                           |[]                                        |
|env_injector.webhook.certificate.useCertManager              |use cert manager to handle webhook certificates| false|
|env_injector.webhook.certificate.custom.enabled              |use custom certs for webhook|false|
|env_injector.webhook.certificate.custom.server.tls.crt       |custom tls cert|""|
|env_injector.webhook.certificate.custom.server.tls.key       |custom tls key|""|
|env_injector.webhook.certificate.custom.ca.crt               |custom ca cert|""|
|env_injector.webhook.dockerImageInspectionTimeout            |max time to inspect docker image and find exec cmd|20 sec|
|env_injector.webhook.failurePolicy                           |if env-injection/webhook fails, fail pod or ignore? |Fail|
|env_injector.webhook.logLevel                                |log level - Trace, Debug, Info, Warning, Error, Fatal or Panic | Info                   |
|env_injector.webhook.logFormat                               |log format - fmt or json | fmt                   |
|env_injector.webhook.podDisruptionBudget.enabled             |if pod disruption budget is enabled          |true                                      |
|env_injector.webhook.podDisruptionBudget.maxUnavailable      |pod disruption maximum unavailable           |nil                                       |
|env_injector.webhook.podDisruptionBudget.minAvailable        |pod disruption minimum available             |1                                         |
|env_injector.webhook.env                                     |Env vars to add to the webhook pod         |{} |
|env_injector.webhook.labels                                  |Labels to add to the webhook deployment    |{} |
|env_injector.webhook.podLabels                               |Labels to add to the webhook pod           |{} |
|env_injector.webhook.securityContext.runAsUser               |Which user to run processes                  |65534|

