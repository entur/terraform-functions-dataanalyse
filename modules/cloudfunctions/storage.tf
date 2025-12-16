# Create GCS bucket for storing function source code
resource "google_storage_bucket" "function_source" {
  name                        = "${var.function_name}-${var.env}-source"
  project                     = module.init.app.project_id
  location                    = local.location
  force_destroy               = true
  uniform_bucket_level_access = true

  labels = local.labels
}

# Create a zip file of the source code
data "archive_file" "source" {
  type        = "zip"
  source_dir  = var.source_dir
  output_path = "${path.module}/.temp/${var.function_name}.zip"
}

# Upload the source code to Cloud Storage
resource "google_storage_bucket_object" "source" {
  name   = "${var.function_name}-${data.archive_file.source.output_md5}.zip"
  bucket = google_storage_bucket.function_source.name
  source = data.archive_file.source.output_path
}