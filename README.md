# Terraform Google Cloud Functions Module

A Terraform module for deploying Google Cloud Functions with comprehensive configuration options, monitoring, and scheduling capabilities.

## Features

- 🚀 **Cloud Functions Deployment**: Deploy Python/Node.js/Go functions to Google Cloud
- ⏰ **Cloud Scheduler Integration**: Built-in cron job scheduling
- 📊 **Monitoring & Alerting**: Automatic alerting for function failures and performance
- 🔒 **Security**: Google Secret Manager integration for sensitive data
- 🏷️ **Resource Organization**: Consistent labeling and naming conventions
- 🔧 **Flexible Configuration**: Extensive customization options

## Usage

### Basic Example

```hcl
module "my_function" {
  source = "github.com/entur/terraform-functions-dataanalyse//modules/cloudfunctions"

  # Required variables
  app_id        = "myapp"
  env           = "dev"
  source_dir    = "./src"
  function_name = "data-processor"
  location      = "europe-west1"

  # Function configuration
  function_config = {
    runtime     = "python313"
    entry_point = "main"
    memory_bytes = 512 * 1024 * 1024  # 512MB
    timeout_sec = 300

    environment_variables = {
      "ENVIRONMENT" = "dev"
      "LOG_LEVEL"   = "INFO"
    }
  }

  # Optional scheduler
  scheduler = {
    crontab  = "0 2 * * *"  # Daily at 2 AM
    timezone = "Europe/Oslo"
  }

  labels = {
    team        = "data"
    environment = "dev"
  }
}
```

### Advanced Configuration

```hcl
module "advanced_function" {
  source = "github.com/entur/terraform-functions-dataanalyse//modules/cloudfunctions"

  app_id        = "datalab"
  env           = "prod"
  source_dir    = "./src"
  function_name = "ml-pipeline"
  location      = "europe-west1"

  function_config = {
    runtime          = "python313"
    entry_point      = "process_data"
    memory_bytes     = 2 * 1024 * 1024 * 1024  # 2GB
    cpu_count        = "2"
    timeout_sec      = 1800
    ingress_settings = "ALLOW_INTERNAL_ONLY"

    environment_variables = {
      "PROJECT_ID"   = "ent-datalab-prod"
      "DATASET_NAME" = "analytics"
    }

    gsm_secrets = {
      "API_KEY"    = "projects/ent-datalab-prod/secrets/api-key/versions/latest"
      "DB_PASSWORD" = "projects/ent-datalab-prod/secrets/db-pass/versions/latest"
    }
  }

  scheduler = {
    crontab                     = "0 */4 * * *"  # Every 4 hours
    timezone                    = "Europe/Oslo"
    retry_count                 = 3
    backoff_duration_seconds    = 300
    alert_notification_channels = ["projects/ent-datalab-prod/notificationChannels/123"]
  }

  alerting = {
    enabled                     = true
    notification_channels       = ["projects/ent-datalab-prod/notificationChannels/456"]
    error_rate_threshold        = 0.05  # 5% error rate
    duration_threshold_seconds  = 600   # 10 minutes
  }

  labels = {
    team        = "ml-ops"
    environment = "prod"
    criticality = "high"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| google | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| google | >= 4.0 |

## Resources Created

- Google Cloud Function (2nd gen)
- Cloud Storage bucket for source code
- Cloud Scheduler job (optional)
- Cloud Monitoring alerting policies (optional)
- IAM roles and bindings

## Module Structure

```
modules/cloudfunctions/
├── main.tf           # Main module configuration
├── variables.tf      # Input variables
├── outputs.tf        # Output values
├── versions.tf       # Provider version constraints
├── function.tf       # Cloud Function resources
├── storage.tf        # Storage bucket for source code
├── scheduler.tf      # Cloud Scheduler configuration
├── alerting.tf       # Monitoring and alerting
├── locals.tf         # Local values and computed expressions
└── templates/        # Template files for alerting
    ├── alerting_filter.tpl
    └── alerting_metric_filter.tpl
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run `terraform fmt` to format your code
5. Submit a pull request

All pull requests are automatically validated using GitHub Actions.

## License

This module is open source and available under standard terms.

## Support

For issues, questions, or contributions, please use the GitHub issue tracker.