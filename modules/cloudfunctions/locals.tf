locals {
  # Labels to apply to all resources
  labels = merge(module.init.labels, var.labels)

  # Service account email
  service_account_email = module.init.service_accounts.default.email

  # Location for all resources (function, scheduler, storage)
  location = var.location
}