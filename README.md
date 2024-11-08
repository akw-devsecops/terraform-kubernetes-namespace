# K8s Namespace Module

Terraform module for creating Kubernetes Namespaces.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_ecr_lifecycle_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_lifecycle_policy) | resource |
| [aws_ecr_repository.application_repos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository) | resource |
| [aws_ecr_repository_policy.application_repos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecr_repository_policy) | resource |
| [aws_s3_bucket.tf_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.tf_states](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.tf_states](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.https_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.tf_state](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.tf_states](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [kubernetes_namespace.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_network_policy.allow_acme](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.allow_dns](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_network_policy.deny_all](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/network_policy) | resource |
| [kubernetes_resource_quota.default](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/resource_quota) | resource |
| [kubernetes_secret_v1.newrelic_license_key](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.application_repos](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.https_only](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Namespace name (e.g. sonarqube or onlineshop-dev) | `string` | n/a | yes |
| <a name="input_additional_ecr_repo_roles"></a> [additional\_ecr\_repo\_roles](#input\_additional\_ecr\_repo\_roles) | Additional roles for cross account push | `list(string)` | `[]` | no |
| <a name="input_additional_namespace_labels"></a> [additional\_namespace\_labels](#input\_additional\_namespace\_labels) | Additional namespace labels | `map(string)` | `{}` | no |
| <a name="input_cpu_quota"></a> [cpu\_quota](#input\_cpu\_quota) | CPU Quota for Namespace | `string` | `"1000m"` | no |
| <a name="input_create_ecr_lifecycle"></a> [create\_ecr\_lifecycle](#input\_create\_ecr\_lifecycle) | Option to disable the ECR lifecycle policy | `bool` | `true` | no |
| <a name="input_create_network_policies"></a> [create\_network\_policies](#input\_create\_network\_policies) | Option to disable network policies | `bool` | `true` | no |
| <a name="input_create_newrelic_license_secret"></a> [create\_newrelic\_license\_secret](#input\_create\_newrelic\_license\_secret) | Option to disable NewRelic license secret creation | `bool` | `false` | no |
| <a name="input_create_state_bucket"></a> [create\_state\_bucket](#input\_create\_state\_bucket) | Option to disable state bucket creation | `bool` | `true` | no |
| <a name="input_ecr_lifecycle_policy"></a> [ecr\_lifecycle\_policy](#input\_ecr\_lifecycle\_policy) | Custom ECR lifecycle policy in JSON format | `string` | `null` | no |
| <a name="input_ecr_repo_role"></a> [ecr\_repo\_role](#input\_ecr\_repo\_role) | Adds role for cross account push | `string` | `""` | no |
| <a name="input_ecr_repos"></a> [ecr\_repos](#input\_ecr\_repos) | Creates an ECR repository for each item passed in the list | `list(string)` | `[]` | no |
| <a name="input_loadbalancer_quota"></a> [loadbalancer\_quota](#input\_loadbalancer\_quota) | Loadbalancer Quota for Namespace | `number` | `0` | no |
| <a name="input_mem_quota"></a> [mem\_quota](#input\_mem\_quota) | Memory Quota for Namespace | `string` | `"2Gi"` | no |
| <a name="input_newrelic_license_key"></a> [newrelic\_license\_key](#input\_newrelic\_license\_key) | NewRelic license key to be stored in a secret | `string` | `null` | no |
| <a name="input_security_level_audit"></a> [security\_level\_audit](#input\_security\_level\_audit) | Policy violations will trigger the addition of an audit annotation to the event recorded in the audit log, but are otherwise allowed. | `string` | `"restricted"` | no |
| <a name="input_security_level_enforce"></a> [security\_level\_enforce](#input\_security\_level\_enforce) | Policy violations will cause the pod to be rejected. | `string` | `"baseline"` | no |
| <a name="input_security_level_warn"></a> [security\_level\_warn](#input\_security\_level\_warn) | Policy violations will trigger a user-facing warning, but are otherwise allowed. | `string` | `"restricted"` | no |
| <a name="input_state_bucket_name"></a> [state\_bucket\_name](#input\_state\_bucket\_name) | Option to override S3 state bucket name | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_name"></a> [name](#output\_name) | n/a |
<!-- END_TF_DOCS -->

## Docs

To update the docs just run
```shell
$ terraform-docs .
```