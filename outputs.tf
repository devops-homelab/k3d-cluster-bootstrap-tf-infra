output "argocd_namespace" {
  description = "The namespace where ArgoCD is installed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_server_service" {
  description = "ArgoCD server service name"
  value       = "argocd-server"
}

output "port_forward_command" {
  description = "Command to port-forward ArgoCD server"
  value       = "kubectl port-forward svc/argocd-server -n ${var.argocd_namespace} 8080:443"
}

output "get_admin_password_command" {
  description = "Command to get the initial admin password"
  value       = "kubectl -n ${var.argocd_namespace} get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 -d"
}

output "root_application_name" {
  description = "Name of the root ArgoCD application"
  value       = kubernetes_manifest.argocd_root_application.manifest.metadata.name
}

output "gitops_repo_url" {
  description = "GitOps repository URL being monitored"
  value       = var.gitops_repo_url
}

output "check_root_application_command" {
  description = "Command to check the root application status"
  value       = "kubectl get application root -n ${var.argocd_namespace}"
}

output "watch_root_application_command" {
  description = "Command to watch the root application sync status"
  value       = "kubectl get application root -n ${var.argocd_namespace} -w"
}
