resource "kubernetes_namespace" "default" {
  metadata {
    name = var.name
    labels = merge(var.additional_namespace_labels, {
      "pod-security.kubernetes.io/enforce" = var.security_level_enforce
      "pod-security.kubernetes.io/audit"   = var.security_level_audit
      "pod-security.kubernetes.io/warn"    = var.security_level_warn
    })
  }
}

resource "kubernetes_resource_quota" "default" {
  metadata {
    name      = "default"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }

  spec {
    hard = {
      "services.loadbalancers" = var.loadbalancer_quota
      "requests.cpu"           = var.cpu_quota
      "requests.memory"        = var.mem_quota
    }
  }
}

resource "kubernetes_secret_v1" "newrelic_license_key" {
  count = var.create_newrelic_license_secret ? 1 : 0

  metadata {
    name      = "newrelic-license"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }
  data = {
    licenseKey = var.newrelic_license_key
  }
}
