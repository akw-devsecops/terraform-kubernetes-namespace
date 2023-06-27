variable "region" {
  description = "AWS region"
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "EKS cluster name"
}

variable "name" {
  type        = string
  description = "Namespace name (e.g. sonarqube or onlineshop-dev)"
}

variable "mem_quota" {
  type        = string
  default     = "2Gi"
  description = "Memory Quota for Namespace"
}

variable "cpu_quota" {
  type        = string
  default     = "1000m"
  description = "CPU Quota for Namespace"
}

variable "ecr_repos" {
  type        = list(string)
  default     = []
  description = "Creates an ECR repository for each item passed in the list"
}

variable "ecr_repo_role" {
  type        = string
  default     = ""
  description = "Adds role for cross account push"
}

variable "additional_ecr_repo_roles" {
  type        = list(string)
  default     = []
  description = "Additional roles for cross account push"
}

variable "create_ecr_lifecycle" {
  type        = bool
  default     = true
  description = "Option to disable the ECR lifecycle policy"
}

variable "policy_boundary_arn" {
  type        = string
  default     = ""
  description = "ARN of IAM policy that will be used as permission boundary"
}

variable "newrelic_license_key" {
  type        = string
  default     = null
  description = "NewRelic license key to be stored in a secret"
}

variable "create_state_bucket" {
  type        = bool
  default     = true
  description = "Option to disable state bucket creation"
}

variable "create_iam_roles" {
  type        = bool
  default     = true
  description = "Option to disable iam view/edit role"
}

variable "create_network_policies" {
  type        = bool
  default     = true
  description = "Option to disable network policies"
}

variable "additional_namespace_labels" {
  type        = map(string)
  default     = {}
  description = "Additional namespace labels"
}

variable "security_level_audit" {
  type        = string
  default     = "restricted"
  description = "Policy violations will trigger the addition of an audit annotation to the event recorded in the audit log, but are otherwise allowed."
}

variable "security_level_enforce" {
  type        = string
  default     = "baseline"
  description = "Policy violations will cause the pod to be rejected."
}

variable "security_level_warn" {
  type        = string
  default     = "restricted"
  description = "Policy violations will trigger a user-facing warning, but are otherwise allowed."
}
