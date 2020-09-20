# Azure Key Vault Custom Resource Definition

## Deprecated

This chart is deprecated. For installing akv2k8s, including CRDs, use the [new Helm 3 Chart](../akv2k8s) or Install the CRD manually by running:

```
kubectl apply -f https://raw.githubusercontent.com/sparebankenvest/azure-key-vault-to-kubernetes/{{ version }}/crds/AzureKeyVaultSecret.yaml
```

---

This sub-chart is used by Azure Key Vault Controller and Azure Key Vault Env Injector, and is not intended to be installed on its own.

For more information about Azure Key Vault Controller and Azure Key Vault Env Injector, see the main GitHub repository at https://github.com/SparebankenVest/azure-key-vault-to-kubernetes.