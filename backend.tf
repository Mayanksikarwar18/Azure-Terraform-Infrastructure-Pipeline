# Terraform Remote State Configuration
# Stored in Azure Blob Storage
# Values can be passed via command line flags (-backend-config) or GitHub Actions secrets

terraform {
  backend "azurerm" {
    # Configured dynamically via -backend-config arguments during 'terraform init':
    # resource_group_name  = "rg-terraform-state"
    # storage_account_name = "<storage_account_name>"
    # container_name       = "tfstate"
    # key                  = "infra.terraform.tfstate"
  }
}
