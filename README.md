# KubeRay Setup

## GKE Cluster
1. Setup terraform
```bash
terraform init
```

1. Apply infra
```bash
terraform apply
```

## Setup KubeRay
1. Add KubeRay Helm repo
```
helm repo add kuberay https://ray-project.github.io/kuberay-helm/
```

2. Install Ray Operator and CRD
```bash
helm install kuberay-operator kuberay/kuberay-operator  \
    --version 1.2.2 \
    --namespace kuberay \
    --create-namespace
```
**optional**
```bash
helm upgrade kuberay-operator kuberay/kuberay-operator  \
    --version 1.2.2 \
    --namespace kuberay 
```

3. Install Ray Cluster CRD
```bash
helm install raycluster kuberay/ray-cluster  \
    --version 1.2.2 \
    -f helm-values/raycluster/values.yaml \
    --namespace kuberay \
    --create-namespace
```
**optional**
```bash
helm upgrade raycluster kuberay/ray-cluster  \
    --version 1.2.2 \
    -f helm-values/raycluster/values.yaml \
    --namespace kuberay 
```

4. Install Ray API Server
```bash
helm install kuberay-apiserver kuberay/kuberay-apiserver  \
    --version 1.2.2 \
    --namespace kuberay \
    --create-namespace
```
**optional**
```bash
helm upgrade kuberay-apiserver kuberay/kuberay-apiserver  \
    --version 1.2.2 \
    --namespace kuberay 
```