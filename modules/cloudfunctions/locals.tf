locals {
  # Labels to apply to all resources
  labels = merge(module.init.labels, var.labels)

  # Service account email
  service_account_email = module.init.service_accounts.default.email

  # Sanitized function name for resources that require restricted characters
  function_name_compact = join("", regexall("[a-z0-9_]", lower(var.function_name)))
  function_name_safe    = can(regex(local.function_name_compact, "^[a-z]")) ? local.function_name_compact : "f${local.function_name_compact}"

  # Location for all resources (function, scheduler, storage)
  location = var.location
}