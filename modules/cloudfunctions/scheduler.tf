# Create Cloud Scheduler job if scheduler is configured
resource "google_cloud_scheduler_job" "scheduler" {
  count = var.scheduler != null ? 1 : 0

  project          = module.init.app.project_id
  region           = local.location
  name             = "scheduler-${var.function_name}"
  description      = "Scheduler for ${var.function_name} Cloud Function"
  schedule         = var.scheduler.crontab
  time_zone        = var.scheduler.timezone
  attempt_deadline = "${var.scheduler.attempt_deadline_seconds}s"

  http_target {
    http_method = "POST"
    uri         = google_cloudfunctions2_function.function.service_config[0].uri

    oidc_token {
      service_account_email = local.service_account_email
      audience              = google_cloudfunctions2_function.function.service_config[0].uri
    }
  }
  retry_config {
    retry_count          = var.scheduler.retry_count
    min_backoff_duration = "${var.scheduler.backoff_duration_seconds}s"
    max_backoff_duration = "${var.scheduler.backoff_duration_seconds}s"
  }
  depends_on = [google_cloudfunctions2_function.function]
}
