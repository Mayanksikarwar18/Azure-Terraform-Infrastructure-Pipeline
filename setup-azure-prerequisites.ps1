<#
.SYNOPSIS
    Bootstraps Azure Remote State Storage & Service Principal for GitHub Actions.
.DESCRIPTION
    Creates:
    1. Azure Resource Group for Terraform State
    2. Azure Storage Account with Blob Container (tfstate)
    3. Azure Service Principal (RBAC: Contributor) for GitHub Actions CI/CD
    4. Displays the required GitHub Secrets to copy into GitHub Settings.
#>

[CmdletBinding()]
param (
    [string]$Location = "eastus",
    [string]$StateResourceGroupName = "rg-tfstate-pipeline",
    [string]$StateContainerName = "tfstate",
    [string]$SpName = "sp-terraform-github-pipeline"
)

Write-Host "=========================================================" -ForegroundColor Cyan
Write-Host " Azure Terraform Infrastructure & CI/CD Bootstrap Script " -ForegroundColor Cyan
Write-Host "=========================================================" -ForegroundColor Cyan

# 1. Verify Azure CLI login
$account = az account show --output json 2>$null | ConvertFrom-Json
if (-not $account) {
    Write-Host "Please login to Azure using 'az login' first." -ForegroundColor Red
    exit 1
}

$subscriptionId = $account.id
$tenantId = $account.tenantId
Write-Host "Active Subscription: $($account.name) ($subscriptionId)" -ForegroundColor Green
Write-Host "Tenant ID:           $tenantId" -ForegroundColor Green

# 2. Create Resource Group for Terraform State
Write-Host "`n[1/4] Creating Resource Group for State Backend: $StateResourceGroupName..." -ForegroundColor Yellow
az group create --name $StateResourceGroupName --location $Location --output none

# 3. Create Storage Account for Remote State (Unique name required)
$randSuffix = -join ((97..122) | Get-Random -Count 6 | ForEach-Object { [char]$_ })
$storageAccountName = "sttfstate$randSuffix"

Write-Host "[2/4] Creating Storage Account: $storageAccountName in $Location..." -ForegroundColor Yellow
az storage account create `
    --name $storageAccountName `
    --resource-group $StateResourceGroupName `
    --location $Location `
    --sku Standard_LRS `
    --encryption-services blob `
    --allow-blob-public-access false `
    --output none

# 4. Create Blob Container for tfstate
Write-Host "[3/4] Creating Blob Container: $StateContainerName..." -ForegroundColor Yellow
$storageKey = (az storage account keys list --resource-group $StateResourceGroupName --account-name $storageAccountName --query "[0].value" --output tsv)

az storage container create `
    --name $StateContainerName `
    --account-name $storageAccountName `
    --account-key $storageKey `
    --output none

# 5. Create Service Principal for GitHub Actions
Write-Host "[4/4] Creating Service Principal: $SpName with Contributor role..." -ForegroundColor Yellow
$scope = "/subscriptions/$subscriptionId"
$spJson = az ad sp create-for-rbac `
    --name $SpName `
    --role "Contributor" `
    --scopes $scope `
    --output json | ConvertFrom-Json

$clientId = $spJson.appId
$clientSecret = $spJson.password

Write-Host "`n=========================================================" -ForegroundColor Green
Write-Host " BOOTSTRAP COMPLETE! Configure your GitHub Secrets:       " -ForegroundColor Green
Write-Host "=========================================================" -ForegroundColor Green
Write-Host "In your GitHub Repository, navigate to:" -ForegroundColor Cyan
Write-Host "Settings -> Secrets and variables -> Actions -> 'New repository secret'`n" -ForegroundColor Cyan

Write-Host "Secret Name: AZURE_CLIENT_ID" -ForegroundColor Yellow
Write-Host "Value:       $clientId`n"

Write-Host "Secret Name: AZURE_CLIENT_SECRET" -ForegroundColor Yellow
Write-Host "Value:       $clientSecret`n"

Write-Host "Secret Name: AZURE_SUBSCRIPTION_ID" -ForegroundColor Yellow
Write-Host "Value:       $subscriptionId`n"

Write-Host "Secret Name: AZURE_TENANT_ID" -ForegroundColor Yellow
Write-Host "Value:       $tenantId`n"

Write-Host "Secret Name: TF_STATE_RESOURCE_GROUP_NAME" -ForegroundColor Yellow
Write-Host "Value:       $StateResourceGroupName`n"

Write-Host "Secret Name: TF_STATE_STORAGE_ACCOUNT_NAME" -ForegroundColor Yellow
Write-Host "Value:       $storageAccountName`n"

Write-Host "Secret Name: TF_STATE_CONTAINER_NAME" -ForegroundColor Yellow
Write-Host "Value:       $StateContainerName`n"

Write-Host "=========================================================" -ForegroundColor Green
