output "scheduler_retry_count" {
  description = "The retry_count for the Cloud Scheduler job."
  value       = var.scheduler != null ? var.scheduler.retry_count : null
}

output "function_uri" {
  description = "URI of the Cloud Function"
  value       = google_cloudfunctions2_function.function.service_config[0].uri
}

output "function_name" {
  description = "Name of the deployed Cloud Function"
  value       = google_cloudfunctions2_function.function.name
}

output "storage_bucket_name" {
  description = "Name of the Cloud Storage bucket used for function source code"
  value       = google_storage_bucket.function_source.name
}

output "service_account_email" {
  description = "Email of the service account used by the function"
  value       = local.service_account_email
}

output "function_location" {
  description = "Location/region where the function is deployed"
  value       = google_cloudfunctions2_function.function.location
}

output "scheduler_job_name" {
  description = "Name of the Cloud Scheduler job (if created)"
  value       = try(google_cloud_scheduler_job.scheduler[0].name, null)
}
