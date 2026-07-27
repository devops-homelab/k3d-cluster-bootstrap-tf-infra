variable "kubeconfig_path" {
  description = "Path to the kubeconfig file"
  type        = string
  default     = "~/.kube/config"
}

variable "kubeconfig_context" {
  description = "Kubernetes context to use"
  type        = string
  default     = null # Uses current context if not specified
}

variable "argocd_namespace" {
  description = "Namespace to install ArgoCD"
  type        = string
  default     = "argocd"
}

variable "argocd_chart_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "7.3.11"
}

variable "gitops_repo_url" {
  description = "URL of the Git repository containing ArgoCD applications"
  type        = string
  default     = "https://github.com/devops-homelab/k3d-gitops"
}

variable "gitops_repo_branch" {
  description = "Git branch to sync from"
  type        = string
  default     = "main"
}

variable "gitops_repo_path" {
  description = "Path within the repository containing application manifests"
  type        = string
  default     = "argocd-apps"
}

variable "github_pat_token" {
  description = "GitHub Personal Access Token for private repository access (requires 'repo' scope)"
  type        = string
  sensitive   = true
  default     = "" # Must be set in terraform.tfvars for private repos
}
