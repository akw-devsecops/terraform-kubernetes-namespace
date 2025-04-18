variable "name" {
  type        = string
  description = "Namespace name (e.g. sonarqube or onlineshop-dev)"
}

variable "create_resource_quota" {
  type        = bool
  default     = true
  description = "Whether to create a resource quota for the namespace"
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

variable "loadbalancer_quota" {
  type        = number
  default     = 0
  description = "Loadbalancer Quota for Namespace"
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

variable "ecr_lifecycle_policy" {
  type        = string
  default     = null
  description = "Custom ECR lifecycle policy in JSON format"
}

variable "create_newrelic_license_secret" {
  type        = bool
  default     = false
  description = "Option to disable NewRelic license secret creation"
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

variable "state_bucket_name" {
  type        = string
  default     = null
  description = "Option to override S3 state bucket name"
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
