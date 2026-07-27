resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
  }
}

resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_chart_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name

  # Wait for the release to be deployed
  wait          = true
  wait_for_jobs = true
  timeout       = 600
  atomic        = true 

  # Default values suitable for local k3d cluster
  values = [file("${path.module}/values/argocd.yaml")]
}
