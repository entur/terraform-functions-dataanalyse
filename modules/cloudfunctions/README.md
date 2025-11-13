# Cloud Functions Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.4.0 |
| <a name="requirement_archive"></a> [archive](#requirement\_archive) | ~>2.3.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=4.47.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_archive"></a> [archive](#provider\_archive) | ~>2.3.0 |
| <a name="provider_google"></a> [google](#provider\_google) | >=4.47.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_init"></a> [init](#module\_init) | github.com/entur/terraform-google-init//modules/init | v1 |

## Resources

| Name | Type |
|------|------|
| [google_cloud_run_service_iam_member.scheduler_invoker](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_run_service_iam_member) | resource |
| [google_cloud_scheduler_job.scheduler](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloud_scheduler_job) | resource |
| [google_cloudfunctions2_function.function](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function) | resource |
| [google_logging_metric.scheduler_final_failure](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/logging_metric) | resource |
| [google_monitoring_alert_policy.scheduler_final_failure_alert](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_storage_bucket.function_source](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket_object.source](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_object) | resource |
| [terraform_data.distinct_function_trigger_check](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |
| [archive_file.source](https://registry.terraform.io/providers/hashicorp/archive/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_id"></a> [app\_id](#input\_app\_id) | Entur app\_id | `string` | n/a | yes |
| <a name="input_env"></a> [env](#input\_env) | Environment prd\|dev\|tst | `string` | n/a | yes |
| <a name="input_function_config"></a> [function\_config](#input\_function\_config) | Cloud Function configuration including runtime, resources, environment variables, and secrets | <pre>object({<br/>    # Function runtime and resources<br/>    runtime          = optional(string, "python313")<br/>    entry_point      = optional(string, "main")<br/>    memory_bytes     = optional(number, 256 * 1024 * 1024)<br/>    cpu_count        = optional(string, "1")<br/>    timeout_sec      = optional(number, 1800)<br/>    ingress_settings = optional(string, "ALLOW_ALL")<br/>    description      = optional(string, "Cloud Function deployed via Terraform")<br/><br/>    # Environment configuration<br/>    environment_variables = optional(map(string), {})<br/>    gsm_secrets           = optional(map(string), {})<br/>  })</pre> | `{}` | no |
| <a name="input_function_name"></a> [function\_name](#input\_function\_name) | Name of the Cloud Function (will be prefixed with ent-{app\_id}-{env}) | `string` | n/a | yes |
| <a name="input_labels"></a> [labels](#input\_labels) | Additional labels to be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | GCP region/location for all resources (function, scheduler, and storage bucket) | `string` | `"europe-west1"` | no |
| <a name="input_pubsub_trigger"></a> [pubsub\_trigger](#input\_pubsub\_trigger) | Pub/Sub trigger configuration. Set to null to disable Pub/Sub triggering. | <pre>object({<br/>    topic_name      = string<br/>    retry_policy    = optional(string, "RETRY_POLICY_RETRY")<br/>    service_account = optional(string, null) # If null, uses default SA<br/>  })</pre> | `null` | no |
| <a name="input_scheduler"></a> [scheduler](#input\_scheduler) | Cloud Scheduler configuration. Set to null to disable scheduling. | <pre>object({<br/>    crontab                     = string<br/>    timezone                    = optional(string, "Europe/Oslo")<br/>    retry_count                 = optional(number, 2)<br/>    backoff_duration_seconds    = optional(number, 300)<br/>    alert_notification_channels = optional(list(string), [])<br/>  })</pre> | `null` | no |
| <a name="input_source_dir"></a> [source\_dir](#input\_source\_dir) | Path to the source code directory to be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_function_location"></a> [function\_location](#output\_function\_location) | Location/region where the function is deployed |
| <a name="output_function_name"></a> [function\_name](#output\_function\_name) | Name of the deployed Cloud Function |
| <a name="output_function_uri"></a> [function\_uri](#output\_function\_uri) | URI of the Cloud Function |
| <a name="output_scheduler_job_name"></a> [scheduler\_job\_name](#output\_scheduler\_job\_name) | Name of the Cloud Scheduler job (if created) |
| <a name="output_scheduler_retry_count"></a> [scheduler\_retry\_count](#output\_scheduler\_retry\_count) | The retry\_count for the Cloud Scheduler job. |
| <a name="output_service_account_email"></a> [service\_account\_email](#output\_service\_account\_email) | Email of the service account used by the function |
| <a name="output_storage_bucket_name"></a> [storage\_bucket\_name](#output\_storage\_bucket\_name) | Name of the Cloud Storage bucket used for function source code |
<!-- END_TF_DOCS -->