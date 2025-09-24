
resource "google_logging_metric" "scheduler_final_failure" {
  project     = module.init.app.project_id
  name        = "scheduler_final_failure_count"
  description = "Counts Cloud Scheduler jobs that failed after all retries."
  filter = templatefile("${path.module}/templates/alerting_filter.tpl", {
    job_id = "scheduler-${var.function_name}"
  })
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"
  }
}

resource "google_monitoring_alert_policy" "scheduler_final_failure_alert" {
  count                 = var.scheduler != null && length(var.scheduler.alert_notification_channels) > 0 ? 1 : 0
  project               = module.init.app.project_id
  display_name          = "Cloud Scheduler Final Failure Alert"
  combiner              = "OR"
  notification_channels = var.scheduler.alert_notification_channels
  user_labels           = local.labels

  conditions {
    display_name = "Scheduler Final Failure Condition"
    condition_threshold {
      filter = templatefile("${path.module}/templates/alerting_metric_filter.tpl", {
        metric_type = "logging.googleapis.com/user/${google_logging_metric.scheduler_final_failure.name}"
      })
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = var.scheduler.retry_count
      trigger {
        count = 1
      }
      aggregations {
        alignment_period   = "${var.scheduler.backoff_duration_seconds * (var.scheduler.retry_count + 1)}s"
        per_series_aligner = "ALIGN_DELTA"
      }
    }
  }

  documentation {
    content   = "${google_cloud_scheduler_job.scheduler[0].name} has failed all retries."
    mime_type = "text/markdown"
  }

  enabled = true
}
