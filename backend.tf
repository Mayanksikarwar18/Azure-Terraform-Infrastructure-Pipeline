# Terraform Remote State Configuration
# Stored in manually created Azure Blob Storage
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-pipeline"
    storage_account_name = "sttfstatepipeline109"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
