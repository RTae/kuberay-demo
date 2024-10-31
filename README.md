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

RaySystemError(RuntimeError('Failed to unpickle serialized exception'), 'Traceback (most recent call last):\n  File "/home/ray/anaconda3/lib/python3.11/site-packages/ray/exceptions.py", line 50, in from_ray_exception\n    return pickle.loads(ray_exception.serialized_exception)

ModuleNotFoundError: No module named \'huggingface_hub.errors\'\n\nThe above exception was the direct cause of the following exception:\n\nTraceback (most recent call last):\n  File "/home/ray/anaconda3/lib/python3.11/site-packages/ray/_private/serialization.py", line 423, in deserialize_objects\n    obj = self._deserialize_object(data, metadata, object_ref)

File "/home/ray/anaconda3/lib/python3.11/site-packages/ray/_private/serialization.py", line 305, in _deserialize_object
return RayError.from_bytes(obj)n  File "/home/ray/anaconda3/lib/python3.11/site-packages/ray/exceptions.py", line 44, in from_bytes\n    return RayError.from_ray_exception(ray_exception)

File "/home/ray/anaconda3/lib/python3.11/site-packages/ray/exceptions.py", line 53, in from_ray_exception\n    raise RuntimeError(msg) from e\nRuntimeError: Failed to unpickle serialized exception\n')