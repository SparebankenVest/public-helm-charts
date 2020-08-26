---
title: "Env-Injector Helm Chart"
description: "Azure Key Vault Env-Injector reference"
---

This chart will install a Custom Resource Definition (`AzureKeyVaultEnvSecret`) and a mutating admission webhook, that together enable transparent injection of Azure Key Vault secrets to containers as environment variables.

For more information see the main GitHub repository at https://github.com/SparebankenVest/azure-key-vault-to-kubernetes.

## Note about installing both Azure Key Vault Env Injector AND Azure Key Vault Controller

If installing both the [Controller](https://github.com/SparebankenVest/public-helm-charts/azure-key-vault-controller) and the Controller, they share the same Custom Resource Definition (CRD), so only one of them can install it. Set `installCrd` to `false` for either this Chart or the [Controller](https://github.com/SparebankenVest/azure-key-vault-controller) Chart. 

## Installing the Chart

```bash
helm repo add spv-charts http://charts.spvapi.no
helm repo update
```

```bash
helm install spv-charts/azure-key-vault-env-injector \
  --namespace akv2k8s
```

**Note: Install akv2k8s in its own dedicated namespace** 

**Note: The Env Injector needs to be enabled for each namespace**

The Env Injector is developed using a Mutating Admission Webhook that triggers just before every Pod gets created. To allow cluster administrators some control over which Pods this Webhook gets triggered for, it must be enabled per namespace using the `azure-key-vault-env-injection` label, like in the example below:

```
apiVersion: v1
kind: Namespace
metadata:
  name: akv-test
  labels:
    azure-key-vault-env-injection: enabled
```

### Installation of both Env Injector and Controller
```bash
helm install spv-charts/azure-key-vault-env-injector \
  --namespace akv2k8s

helm install spv-charts/azure-key-vault-controller \
    --set installCrd=false  --namespace akv2k8s
```

### Using custom authentication with AAD Pod Identity

Requires Pod Identity: https://github.com/Azure/aad-pod-identity

```bash
helm install spv-charts/azure-key-vault-env-injector \
  --namespace akv2k8s \
  --set keyVault.customAuth.enabled=true \
```

When deploying Pods, set the `aadpodidbinding` according to the 
[AAD Pod Identity project docs](https://github.com/Azure/aad-pod-identity/blob/master/README.md) and
the env-injector will use these credentials when communicating with Azure Key Vault.

### Using custom authentication with Service Principal

```bash
helm install spv-charts/azure-key-vault-env-injector \
  --namespace akv2k8s \
  --set keyVault.customAuth.enabled=true \
  --set env.AZURE_TENANT_ID=... \
  --set env.AZURE_CLIENT_ID=... \
  --set env.AZURE_CLIENT_SECRET=...
```

### Disable central authentication, leaving all AKV authentication to individual Pods
```bash
helm install spv-charts/azure-key-vault-env-injector \
  --namespace akv2k8s \
  --set authService.enabled=false
```

See [Custom Authentication Options](https://akv2k8s.io/security/authentication/#custom-authentication-options) in the akv2k8s documentation for how you can configure individual pods with auth. 

## Configuration

The following tables lists configurable parameters of the azure-key-vault-env-injector chart and their default values.

|               Parameter                        |                Description                  |                  Default                 |
| ---------------------------------------------- | ------------------------------------------- | -----------------------------------------|
|affinity                                        |affinities to use                            |{}                                        |
|authService.enabled                             |if authservice is used for central akv authentication|true|
|authService.caBundleController.image.repository |image repository for ca bundler|spvest/ca-bundle-controller|
|authService.caBundleController.image.tag        |image tag for ca bundler|1.1.0-beta.24|
|authService.caBundleController.image.pullPolicy |pull policy for ca bundler|IfNotPresent|
|authService.caBundleController.logLevel         |log level - Trace, Debug, Info, Warning, Error, Fatal or Panic|Info|
|authService.caBundleController.akvLabelName     |akv label used in namespaces|azure-key-vault-env-injection|
|authService.caBundleController.configMapName    |configmap name to store ca cert|akv2k8s-ca|
|cloudConfigHostPath                             |path to azure cloud config                   |/etc/kubernetes/azure.json                |
|env                                             |aditional env vars to send to pod            |{}                                        |
|envImage.repository                             |image repo that contains the env image       |spvest/azure-keyvault-env                 |
|envImage.tag                                    |image tag                                    |1.0.2                                    |
|image.pullPolicy                                |image pull policy                            |IfNotPresent                              |
|image.repository                                |image repo that contains the controller      |spvest/azure-keyvault-webhook             |
|image.tag                                       |image tag                                    |1.0.2                                    |
|installCrd                                      |install custom resource definition           |true                                      |
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
|webhook.dockerImageInspectionTimeout            |max time to inspect docker image and find exec cmd|20 sec|
|webhook.failurePolicy                           |  |Ignore|
|webhook.podDisruptionBudget.enabled             |if pod disruption budget is enabled          |true                                      |
|webhook.podDisruptionBudget.minAvailable        |pod disruption minimum available             |1                                         |
|webhook.podDisruptionBudget.maxUnavailable      |pod disruption maximum unavailable           |nil                                       |
