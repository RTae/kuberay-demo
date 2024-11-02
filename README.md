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

## Demo setup
1. Cluster connection
```bash
gcloud container clusters get-credentials tae-test --zone asia-southeast1-c --project rtae-lab
```

2. Create namespace
```bash
kubectl create ns workspace
```

## Demo KubeRay Service
1. Setup Hugging face
```bash
export HF_TOKEN=<Hugging Face access token>
kubectl create secret generic hf-secret --from-literal=hf_api_token=${HF_TOKEN} --dry-run=client -n workspace -o yaml | kubectl apply -f -
```

## Setup Nginx
1. Add Nginx Helm repo
```
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```
2. Install Nginx
```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
    --version 4.11.3 \
    --namespace ingress-nginx \
    --create-namespace
```
**optional**
```bash
helm upgrade ingress-nginx ingress-nginx/ingress-nginx \
    --version 4.11.3 \
    --namespace ingress-nginx \
    --create-namespace
```

## Setup Cert-manager
1. Add Cert Manager Helm repro
```bash
helm repo add jetstack https://charts.jetstack.io
```

2. Install Cert Manager
```bash
helm install cert-manager jetstack/cert-manager \
    --version v1.16.1 \
    --namespace cert-manager \
    --create-namespace \
    --set crds.enabled=true
```

3. Install cert config
```bash
kubectl apply -f ./dependency/cert-manager/cert.yaml
```
**optional**
```bash
helm upgrade cert-manager jetstack/cert-manager \
    --version v1.16.1 \
    --namespace cert-manager \
    --set crds.enabled=true
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

3. Install Ray API Server
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