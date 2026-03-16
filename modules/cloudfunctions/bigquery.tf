# BigQuery remote function resources
# Creates a BQ connection, grants the connection SA invoker access, and creates remote function routines

resource "google_bigquery_connection" "remote_function" {
  count         = var.bigquery_remote_function != null ? 1 : 0
  connection_id = var.bigquery_remote_function.connection_id
  project       = module.init.app.project_id
  location      = coalesce(var.bigquery_remote_function.location, var.location)

  cloud_resource {}
}

resource "google_cloud_run_service_iam_member" "bq_remote_function_invoker" {
  count    = var.bigquery_remote_function != null ? 1 : 0
  project  = module.init.app.project_id
  location = local.location
  service  = google_cloudfunctions2_function.function.name
  role     = "roles/run.invoker"
  member   = "serviceAccount:${google_bigquery_connection.remote_function[0].cloud_resource[0].service_account_id}"

  depends_on = [google_cloudfunctions2_function.function]
}

resource "google_bigquery_routine" "remote_function" {
  for_each = var.bigquery_remote_function != null ? var.bigquery_remote_function.routines : {}

  project         = module.init.app.project_id
  dataset_id      = each.value.dataset_id
  routine_id      = each.key
  routine_type    = each.value.routine_type
  description     = each.value.description
  definition_body = ""

  dynamic "arguments" {
    for_each = each.value.arguments
    content {
      name      = arguments.value.name
      data_type = arguments.value.data_type
    }
  }

  return_type = each.value.return_type

  remote_function_options {
    endpoint             = google_cloudfunctions2_function.function.service_config[0].uri
    connection           = google_bigquery_connection.remote_function[0].name
    user_defined_context = each.value.user_defined_context
  }
}
