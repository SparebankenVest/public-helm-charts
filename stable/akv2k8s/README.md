# akv2k8s Helm Chart (Helm 3)

A Helm chart that deploys akv2k8s Controller and Env-Injector to Kubernetes

![Version: 2.0.0-beta.49](https://img.shields.io/badge/Version-2.0.0--beta.49-informational?style=flat-square) ![AppVersion: 1.2.0-beta.42](https://img.shields.io/badge/AppVersion-1.2.0--beta.42-informational?style=flat-square)

This chart will install:
  * a Controller for syncing AKV secrets to Kubernetes secrets
  * a Env-Injector enabling transparent environment injection of AKV secrets into container programs

For more information and installation instructions see the official documentation at https://akv2k8s.io

## Helm Chart and akv2k8s Versions

| Helm Chart | Controller | Env Injector | CA Bundle Controller | Env Injector Sidecar |
|-----|------|---------|-------| -------------|
| `2.0.0-beta.49` | `