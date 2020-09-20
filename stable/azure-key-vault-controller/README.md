---
title: "Controller Helm Chart"
description: "Azure Key Vault Controller reference"
---

This chart will install a Kubernetes controller and a Custom Resource Definition (`AzureKeyVaultSecret`), that together enable secrets from Azure Key Vault to be stored as Kubernetes native `Secret` resources.

For more information see the main GitHub repository at https://github.com/SparebankenVest/azure-key-vault-to-kubernetes.

## Installation

### Installing the CRD

Before installing the Chart, the Custom Resource Definition must be installed.

```
kubectl apply -f https://raw.githubusercontent.com/sparebankenvest/azure-key-vault-to-kubernetes/crd-{{ version }}/crds/AzureKeyVaultSecret.yaml
```

### Installing the Chart

```bash
helm repo add spv-charts http://charts.spvapi.no
helm repo update
```

```bash
helm upgrade -i azure-key-vault-controller spv-charts/azure-key-vault-controller \
    --namespace akv2k8s
```

### Installing both the Controller and Env Injector

```bash
helm upgrade -i azure-key-vault-controller spv-charts/azure-key-vault-controller \
    --namespace akv2k8s

helm upgrade -i azure-key-vault-env-injector spv-charts/azure-key-vault-env-injector \
  --namespace akv2k8s
```

## Using custom authentication

```bash
helm install spv-charts/azure-key-vault-env-injector \
  --set keyVault.customAuth.enabled=true \
  --set env.AZURE_TENANT_ID=... \
  --set env.AZURE_CLIENT_ID=... \
  --set env.AZURE_CLIENT_SECRET=...
```

## Configuration

The following table lists configurable parameters of the azure-key-vault-controller chart and their default values.

|               Parameter                |                Description                   |                  Default                 |
| -------------------------------------- | -------------------------------------------- | -----------------------------------------|
|env                                     |aditional env vars to send to pod             |{}                                        |
|image.repository                        |image repo that contains the controller image | spvest/azure-keyvault-controller         |
|image.tag                               |image tag|1.0.2|
|image.pullPolicy                        |pull policy | IfNotPresent |
|installCrd                              |install custom resource definition           |true                                      |
|keyVault.customAuth.enabled             |if custom auth is enabled | false |
|keyVault.polling.normalInterval         |interval to wait before polling azure key vault for secret updates | 1m |
|keyVault.polling.failureInterval        |interval to wait when polling has failed `failureAttempts` before polling azure key vault for secret updates | 5m |
|keyVault.polling.failureAttempts        |number of times to allow secret updates to fail before applying `failureInterval` | 5 |
|labels                                  |any additional labels | {}
|logFormat                               |log format - fmt or json | fmt                   |
|logLevel                                |log level | info |
|podLabels                               |any additional labels | {}
