# Contributing

Documentation are manually generated via [helm-docs](https://github.com/norwoodj/helm-docs) before commiting and using the template `README.md.gotmpl`

```
brew install norwoodj/tap/helm-docs
```

Generate documentation

```shell
cd stable/akv2k8s
helm-docs -s file
```

or

```shell
helm-docs -s file -c stable/akv2k8s/
```
