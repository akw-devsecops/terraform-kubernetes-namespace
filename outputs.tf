output "name" {
  value = kubernetes_namespace.default.metadata[0].name
}
