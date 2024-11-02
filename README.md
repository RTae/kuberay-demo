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