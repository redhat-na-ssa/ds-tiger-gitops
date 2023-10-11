# OpenShift AI / ML GitOps Catalog

[![Spelling](https://github.com/codekow/demo-ai-gitops-catalog/actions/workflows/spellcheck.yaml/badge.svg)](https://github.com/codekow/demo-ai-gitops-catalog/actions/workflows/spellcheck.yaml)
[![Linting](https://github.com/codekow/demo-ai-gitops-catalog/actions/workflows/linting.yaml/badge.svg)](https://github.com/codekow/demo-ai-gitops-catalog/actions/workflows/linting.yaml)

This project is a catalog of configurations used to provision infrastructure, on
OpenShift, that supports machine learning (ML) and artificial intelligence (AI) workloads.

**This repo is subject to frequent, breaking changes!**

## Prerequisites

- OpenShift 4.8+

Red Hat Demo Platform Options

- `MLOps Demo: Data Science & Edge Practice`
- `Red Hat OpenShift Container Platform 4 Demo`

### Tools

The following cli tools are required:

- `bash`
- `oc` - Download [mac](https://formulae.brew.sh/formula/openshift-cli), [linux](https://mirror.openshift.com/pub/openshift-v4/clients)
- `kubectl` (optional) - Included in `oc` bundle
- `kustomize` (optional) - Download [mac](https://formulae.brew.sh/formula/kustomize), [linux](https://github.com/kubernetes-sigs/kustomize/releases)

## Bootstrapping a Cluster

1. Verify you are logged into your cluster using `oc`.
1. Clone this repository to your local environment.

```sh
oc whoami
git clone <repo>
```

### Cluster Quick Start

Execute the following script:

```sh
./scripts/bootstrap.sh
```

The `bootstrap.sh` script will:

- Install the [OpenShift GitOps Operator](components/operators/openshift-gitops-operator)
- Create an [ArgoCD instance](components/operators/openshift-gitops-operator/instance/base/openshift-gitops-cr.yaml) in the `openshift-gitops` namespace
<!-- - Bootstrap a set of ArgoCD applications to configure the cluster -->

You can run individual [functions](scripts/functions.sh) in a `bash` shell:

```sh
source scripts/functions.sh
```

<!-- ### Sealed Secrets Bootstrap

`bootstrap.sh` will attempt to deploy sealed-secrets and requires a sealed secret master key to manage existing deployments.  

If managing an already bootstrapped cluster, the sealed-secrets key must be obtained from the initial bootstrap (ask the person who initially setup the cluster).

The sealed secret(s) for bootstrap should be located at:

```sh
bootstrap/sealed-secrets-secret.yaml
```

If this is the first time bootstrapping a cluster, `bootstrap.sh` will deploy a new sealed-secrets controller and obtain a new secret if it does not exist. -->

## Additional Configurations

### Sandbox Namespace

The `sandbox` [namespace](components/configs/namespaces/instance/sandbox/namespace.yaml) is useable by all [authenticated users](components/configs/namespaces/instance/sandbox/rolebinding-edit.yaml). All objects in the sandbox are [cleaned out weekly](components/configs/simple/sandbox-cleanup/sandbox-cleanup-cj.yml).

## Contributions

Please run the following before submitting a PR / commit

```sh
scripts/lint.sh
```

## Additional Info

- [GitOps Catalog](https://github.com/redhat-cop/gitops-catalog)
- [Repo Docs](docs) - not everything fits in your head
- [Using this repo effectively](docs/APPS.md)
- [Fix GitHub Oauth](docs/LOGIN.md)
- [ArgoCD - Repo Specific](docs/ARGOCD.md)

## External Links

- [ArgoCD - Example](https://github.com/gnunn-gitops/cluster-config)
- [ArgoCD - Patterns](https://github.com/gnunn-gitops/standards)
