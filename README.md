# k3d Cluster Bootstrap with ArgoCD

![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.0-blue)
![License](https://img.shields.io/badge/License-MIT-green)

A production-ready Terraform configuration for bootstrapping a local k3d Kubernetes cluster with ArgoCD installed and configured via Helm.

## 🎯 Overview

This infrastructure-as-code project provides:
- **Local k3d Kubernetes cluster** setup and management
- **ArgoCD deployment** using Helm provider for GitOps workflow
- **Configurable versions** for both Helm chart and ArgoCD application
- **Environment isolation** with dedicated namespaces
- **Example values** for local development optimization

Perfect for:
- Local development and testing
- GitOps workflow experimentation
- Kubernetes learning and prototyping
- CI/CD pipeline development

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) ≥ 1.0
- [kubectl](https://kubernetes.io/docs/tasks/tools/) configured
- [k3d](https://k3d.io/#installation) installed and running
- [Helm](https://helm.sh/docs/intro/install/) (for manual operations)

### Quick k3d Cluster Setup

```bash
# Create a k3d cluster
k3d cluster create my-k8s-cluster

# List clusters
k3d cluster list

# Get kubeconfig
k3d kubeconfig get my-k8s-cluster > ~/.kube/config
```

## 📁 Project Structure

```
k3d-cluster-bootstrap-tf-infra/
├── main.tf              # ArgoCD Helm release and namespace resources
├── providers.tf         # Kubernetes and Helm provider configuration
├── variables.tf         # Input variables and defaults
├── outputs.tf           # Output values for ArgoCD access
├── terraform.tfvars     # Terraform variables (customize for your environment)
├── values/
│   └── argocd.yaml      # ArgoCD Helm chart values
├── .gitignore           # Git ignore rules
├── .terraform.lock.hcl  # Provider version lock (commit to repo)
└── README.md            # This file
```

## 🚀 Quick Start

### 1. Initialize Terraform

```bash
cd k3d-cluster-bootstrap-tf-infra
terraform init
```

### 2. Configure Variables

Edit `terraform.tfvars` with your k3d cluster settings:

```hcl
# Path to kubeconfig
kubeconfig_path = "~/.kube/config"

# K3d cluster context name (get with: kubectl config current-context)
kubeconfig_context = "k3d-my-k8s-cluster"

# ArgoCD namespace
argocd_namespace = "argocd"

# ArgoCD Helm chart version
argocd_chart_version = "7.3.11"

# (Optional) Custom values for ArgoCD
argocd_values = {
  server = {
    ingress = {
      enabled = false
    }
  }
}
```

### 3. Plan and Apply

```bash
# Review changes
terraform plan

# Deploy ArgoCD
terraform apply
```

## ⚙️ Configuration

### Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `kubeconfig_path` | string | `~/.kube/config` | Path to kubeconfig file |
| `kubeconfig_context` | string | `null` | Kubernetes context (uses current if null) |
| `argocd_namespace` | string | `argocd` | Namespace for ArgoCD |
| `argocd_chart_version` | string | `7.3.11` | Helm chart version |
| `argocd_values` | object | `{}` | Additional Helm values |

### ArgoCD Helm Values

Default values in `values/argocd.yaml` are optimized for local k3d development:
- Reduced resource requests (CPU/memory)
- ClusterIP service (no LoadBalancer)
- TLS disabled for local development
- Optimized for low-resource environments

Customize by editing `values/argocd.yaml` or passing additional values via `terraform.tfvars`:

```hcl
argocd_values = {
  server = {
    ingress = {
      enabled     = true
      ingressClassName = "traefik"
      hosts = ["argocd.local"]
    }
  }
  redis = {
    resources = {
      requests = {
        cpu    = "100m"
        memory = "128Mi"
      }
    }
  }
}
```

## 📤 Outputs

After successful deployment, Terraform outputs helpful information:

```bash
terraform output
```

Available outputs:
- `argocd_namespace` - Namespace where ArgoCD is installed
- `argocd_server_service` - ArgoCD server service name
- `port_forward_command` - Command to port-forward ArgoCD
- `get_admin_password_command` - Command to retrieve admin password

## 🔐 Access ArgoCD

### Port-Forward to ArgoCD Server

```bash
kubectl port-forward svc/argocd-server -n argocd 8080:443
```

### Get Admin Password

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d
```

### Login

- **URL:** https://localhost:8080
- **Username:** `admin`
- **Password:** (from command above)

> ⚠️ Change the default password in ArgoCD UI after first login

## 🔍 Verify Installation

```bash
# Check ArgoCD pods
kubectl get pods -n argocd

# Check services
kubectl get svc -n argocd

# Verify Helm release
helm list -n argocd
```

## 🧹 Cleanup

Remove all resources:

```bash
terraform destroy
```

Delete the k3d cluster:

```bash
k3d cluster delete my-k8s-cluster
```

## 📝 Common Operations

### Update ArgoCD Version

Edit `terraform.tfvars`:
```hcl
argocd_chart_version = "7.4.0"  # Update chart version
```

Then:
```bash
terraform plan
terraform apply
```

### Enable ArgoCD Ingress

Update `terraform.tfvars`:
```hcl
argocd_values = {
  server = {
    ingress = {
      enabled           = true
      ingressClassName  = "traefik"
      hosts             = ["argocd.local"]
    }
  }
}
```

### Reset Admin Password

```bash
kubectl patch secret argocd-secret -n argocd \
  -p '{"data": {"admin.password": "'$(echo -n "newpassword" | base64)'"}}' \
  -p '{"data": {"admin.passwordMtime": "'$(date +%s | base64)'"}}' \
  --type merge
```

## 🐛 Troubleshooting

### ArgoCD pods not starting

```bash
# Check pod logs
kubectl logs -n argocd -l app.kubernetes.io/name=argocd-server

# Check events
kubectl describe pod -n argocd <pod-name>

# Check helm status
helm status argocd -n argocd
```

### Terraform provider errors

```bash
# Reinitialize providers
rm -rf .terraform
terraform init
```

### Kubeconfig issues

Verify kubeconfig context:
```bash
kubectl config current-context
kubectl config get-contexts
```

## 🔗 Resources

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [Terraform Helm Provider](https://registry.terraform.io/providers/hashicorp/helm/latest/docs)
- [k3d Documentation](https://k3d.io/)
- [ArgoCD Helm Chart](https://github.com/argoproj/argo-helm)

## 📄 License

MIT License - see LICENSE file for details

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## ❓ Questions or Issues?

Open an issue in the repository with:
- Your k3d cluster version
- Terraform version
- Error messages and logs
- Steps to reproduce
