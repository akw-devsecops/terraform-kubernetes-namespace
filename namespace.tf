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
      "services.loadbalancers" = 0
      "requests.cpu"           = var.cpu_quota
      "requests.memory"        = var.mem_quota
    }
  }
}

resource "kubernetes_secret_v1" "newrelic_license_key" {
  count = var.newrelic_license_key != null ? 1 : 0

  metadata {
    name      = "newrelic-license"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }
  data = {
    licenseKey = var.newrelic_license_key
  }
}

resource "kubernetes_role_binding" "view" {
  count = var.create_iam_roles ? 1 : 0

  metadata {
    name      = "${kubernetes_namespace.default.metadata[0].name}-view"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "view"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "${kubernetes_namespace.default.metadata[0].name}-view"
  }
}

resource "kubernetes_role_binding" "edit" {
  count = var.create_iam_roles ? 1 : 0

  metadata {
    name      = "${kubernetes_namespace.default.metadata[0].name}-edit"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "edit"
  }

  subject {
    api_group = "rbac.authorization.k8s.io"
    kind      = "Group"
    name      = "${kubernetes_namespace.default.metadata[0].name}-edit"
  }
}
