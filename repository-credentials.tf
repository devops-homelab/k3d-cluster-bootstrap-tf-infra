# Kubernetes Secret for GitHub repository access using Personal Access Token
# ArgoCD will use this secret to authenticate with private GitHub repositories

resource "kubernetes_secret" "github_repo_creds" {
  metadata {
    name      = "github-repo-creds"
    namespace = kubernetes_namespace.argocd.metadata[0].name
    labels = {
      # ArgoCD looks for this label to identify repository credentials
      "argocd.argoproj.io/secret-type" = "repository"
    }
  }

  type = "Opaque"

  data = {
    type     = "git"
    url      = var.gitops_repo_url
    password = var.github_pat_token
    username = "git" # Required even though we're using token auth
  }

  depends_on = [kubernetes_namespace.argocd]
}
