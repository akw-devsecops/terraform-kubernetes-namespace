resource "kubernetes_network_policy" "deny_all" {
  count = var.create_network_policies ? 1 : 0

  metadata {
    name      = "default-deny-all"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }

  spec {
    policy_types = [
      "Ingress",
      "Egress"
    ]

    pod_selector {}
  }
}

resource "kubernetes_network_policy" "allow_dns" {
  count = var.create_network_policies ? 1 : 0

  metadata {
    name      = "default-allow-dns"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }
  spec {
    pod_selector {}
    policy_types = ["Egress"]

    egress {
      to {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
        pod_selector {
          match_labels = {
            "k8s-app" = "kube-dns"
          }
        }
      }
      ports {
        port     = "53"
        protocol = "UDP"
      }
    }
  }
}

resource "kubernetes_network_policy" "allow_acme" {
  count = var.create_network_policies ? 1 : 0

  metadata {
    name      = "default-allow-acme"
    namespace = kubernetes_namespace.default.metadata[0].name
    labels    = var.additional_namespace_labels
  }
  spec {
    pod_selector {
      match_labels = {
        "acme.cert-manager.io/http01-solver" = "true"
      }
    }
    policy_types = ["Ingress"]

    ingress {
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "ingress-nginx"
          }
        }
      }
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "nginx"
          }
        }
      }
      from {
        namespace_selector {
          match_labels = {
            "kubernetes.io/metadata.name" = "kube-system"
          }
        }
        pod_selector {
          match_labels = {
            "app.kubernetes.io/name" = "cert-manager"
          }
        }
      }
      ports {
        port     = "8089"
        protocol = "TCP"
      }
    }
  }
}
