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
```
helm install kuberay-operator kuberay/kuberay-operator  \
    --version 1.2.2 \
    --namespace kuberay \
    --create-namespace
```

3. Install Ray Cluster CRD
```
helm install raycluster kuberay/ray-cluster  \
    --version 1.2.2 \
    -f helm-values/raycluster/values.yaml \
    --namespace kuberay \
    --create-namespace
```

4. Install Ray API Server
```
helm install kuberay-apiserver kuberay/kuberay-apiserver  \
    --version 1.2.2 \
    --namespace kuberay \
    --create-namespace
```