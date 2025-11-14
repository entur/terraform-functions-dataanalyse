# Create the Cloud Run function (2nd gen)
resource "google_cloudfunctions2_function" "function" {
  name        = var.function_name
  location    = local.location
  project     = module.init.app.project_id
  description = var.function_config.description

  build_config {
    runtime     = var.function_config.runtime
    entry_point = var.function_config.entry_point

    source {
      storage_source {
        bucket = google_storage_bucket.function_source.name
        object = google_storage_bucket_object.source.name
      }
    }
  }

  service_config {
    available_memory      = var.function_config.memory_bytes
    available_cpu         = tostring(var.function_config.cpu_count)
    timeout_seconds       = var.function_config.timeout_sec
    service_account_email = local.service_account_email
    ingress_settings      = var.function_config.ingress_settings

    # Set environment variables
    environment_variables = var.function_config.environment_variables

    # Set secret environment variables  
    dynamic "secret_environment_variables" {
      for_each = var.function_config.gsm_secrets
      content {
        key        = secret_environment_variables.value
        project_id = module.init.app.project_id
        secret     = secret_environment_variables.key
        version    = "latest"
      }
    }
  }

  # Add Pub/Sub event trigger if configured
  dynamic "event_trigger" {
    for_each = var.pubsub_trigger != null ? [1] : []
    content {
      trigger_region        = local.location
      event_type            = "google.cloud.pubsub.topic.v1.messagePublished"
      pubsub_topic          = "projects/${module.init.app.project_id}/topics/${var.pubsub_trigger.topic_name}"
      retry_policy          = var.pubsub_trigger.retry_policy
      service_account_email = var.pubsub_trigger.service_account != null ? var.pubsub_trigger.service_account : local.service_account_email
    }
  }

  labels = local.labels

  depends_on = [
    google_storage_bucket_object.source
  ]
}

resource "terraform_data" "distinct_function_trigger_check" {
  count = local.unique_functions_trigger ? 0 : 1
  provisioner "local-exec" {
    command = ">&2 echo 'You may specify either pubsub_trigger or scheduler, not both.'; exit 1"
  }
}


# Grant Cloud Run Invoker role to the Cloud Scheduler service account if scheduler is enabled
# Note: Not needed for Pub/Sub triggers as they use event-driven invocation
resource "google_cloud_run_service_iam_member" "scheduler_invoker" {
  count      = var.scheduler != null && var.pubsub_trigger == null ? 1 : 0
  project    = module.init.app.project_id
  location   = local.location
  service    = google_cloudfunctions2_function.function.name
  role       = "roles/run.invoker"
  member     = "serviceAccount:${local.service_account_email}"
  depends_on = [google_cloudfunctions2_function.function]
}
