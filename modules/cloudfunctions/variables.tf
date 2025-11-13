# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED PARAMETERS
# You must provide a value for each of these parameters.
# ---------------------------------------------------------------------------------------------------------------------

variable "app_id" {
  description = "Entur app_id"
  type        = string
}

variable "env" {
  description = "Environment prd|dev|tst"
  type        = string
}

variable "source_dir" {
  description = "Path to the source code directory to be deployed"
  type        = string
}

variable "function_name" {
  description = "Name of the Cloud Function (will be prefixed with ent-{app_id}-{env})"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------

variable "function_config" {
  description = "Cloud Function configuration including runtime, resources, environment variables, and secrets"
  type = object({
    # Function runtime and resources
    runtime          = optional(string, "python313")
    entry_point      = optional(string, "main")
    memory_bytes     = optional(number, 256 * 1024 * 1024)
    cpu_count        = optional(number, 1)
    timeout_sec      = optional(number, 1800)
    ingress_settings = optional(string, "ALLOW_ALL")
    description      = optional(string, "Cloud Function deployed via Terraform")

    # Environment configuration
    environment_variables = optional(map(string), {})
    gsm_secrets           = optional(map(string), {})
  })
  default = {}
}

variable "scheduler" {
  description = "Cloud Scheduler configuration. Set to null to disable scheduling."
  type = object({
    crontab                     = string
    timezone                    = optional(string, "Europe/Oslo")
    retry_count                 = optional(number, 2)
    backoff_duration_seconds    = optional(number, 300)
    alert_notification_channels = optional(list(string), [])
  })
  default = null
}

variable "location" {
  description = "GCP region/location for all resources (function, scheduler, and storage bucket)"
  type        = string
  default     = "europe-west1"
}

variable "labels" {
  description = "Additional labels to be applied to all resources"
  type        = map(string)
  default     = {}
}

variable "pubsub_trigger" {
  description = "Pub/Sub trigger configuration. Set to null to disable Pub/Sub triggering."
  type = object({
    topic_name      = string
    retry_policy    = optional(string, "RETRY_POLICY_RETRY")
    service_account = optional(string, null) # If null, uses default SA
  })
  default = null
}
