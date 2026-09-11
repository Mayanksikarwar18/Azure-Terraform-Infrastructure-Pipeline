# Azure Terraform Infrastructure Pipeline (Parent-Child Modules & GitHub Actions)

A complete, production-ready Infrastructure as Code (IaC) project designed to provision core Azure networking and compute infrastructure using Terraform with a **Parent-Child module architecture**, orchestrated via **GitHub Actions CI/CD**.

---

## 🏗️ Architecture & Resources

This project provisions the following Azure resources in a modular parent-child hierarchy:

1. **Resource Group**: Central management container for all provisioned services.
2. **Virtual Network (VNet)**: Isolated address space (`10.0.0.0/16` by default).
3. **Subnet**: Dedicated workload subnet (`10.0.1.0/24`).
4. **NAT Gateway**:
   - Standard Public IP allocated to the NAT Gateway.
   - NAT Gateway associated with the subnet, enabling secure, outbound-only internet connectivity for internal workloads.
5. **VM Public IP**:
   - Dedicated Standard SKU Static Public IP attached to the VM Network Interface.
   - Optional DNS prefix configuration (`<label>.<region>.cloudapp.azure.com`).
6. **Network Security Group (NSG)**:
   - Security rules for SSH (port 22), HTTP (port 80), HTTPS (port 443), and custom application ports (port 8080).
   - Associated with the subnet and network interface.
7. **Network Interface (NIC)**:
   - Private IP assigned from the subnet and attached to the VM Public IP.
   - Tied to the Network Security Group.
8. **Virtual Machine (Linux) & Application Bootstrapping**:
   - Ubuntu 22.04 LTS Gen2 instance (`Standard_B2as_v2` - 2 vCPUs, 8 GiB RAM).

   - SSH Key management (can auto-generate RSA key pair or accept an existing SSH public key).
   - Cloud-init script automatically boots Nginx and runs an application status dashboard listening on ports 80 & 8080, fully integrated with Azure infrastructure.

```
                 +-------------------------------------------------------------+
                 |                   Azure Resource Group                      |
                 |                                                             |
                 |   +-----------------------------------------------------+   |
                 |   |                   Virtual Network                   |   |
                 |   |                                                     |   |
                 |   |   +---------------------------------------------+   |   |
                 |   |   |                   Subnet                    |   |   |
                 |   |   |                                             |   |   |
                 |   |   |   +----------------+   +----------------+   |   |   |
                 |   |   |   |  Linux VM & App|   |  NAT Gateway   |   |   |   |
                 |   |   |   |  (Ubuntu 22.04)|   |  & Public IP   |   |   |   |
                 |   |   |   +--------+-------+   +--------+-------+   |   |   |
                 |   |   |            |                    |           |   |   |
                 |   |   |      [VM Public IP]        [Outbound]       |   |   |
                 |   |   |      [Private NIC ]             |           |   |   |
                 |   |   |            |                    |           |   |   |
                 |   |   |            v                    v           |   |   |
                 |   |   |     [NSG: 80,443,8080,22]  [ Internet ]     |   |   |
                 |   |   |            |                                |   |   |
                 |   |   |            v                                |   |   |
                 |   |   |     [Inbound Traffic]                       |   |   |
                 |   |   +---------------------------------------------+   |   |
                 |   +-----------------------------------------------------+   |
                 +-------------------------------------------------------------+
```

---

## 📂 Repository Layout

```
azure-terraform-infra-pipeline/
├── .github/
│   └── workflows/
│       ├── terraform-ci.yml           # Pull Request workflow: fmt, init, validate, plan
│       └── terraform-cd.yml           # Main workflow: automated plan & apply on push or dispatch
├── modules/                           # Reusable Child Modules
│   ├── resource_group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── virtual_network/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── subnet/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── public_ip/                     # VM Standard Public IP module
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── nat_gateway/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network_security_group/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   ├── network_interface/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   └── outputs.tf
│   └── virtual_machine/
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── templates/
│   └── cloud-init.yaml                # Application bootstrap script for VM
├── main.tf                            # Parent / Root Module calling child modules
├── variables.tf                       # Root variable declarations
├── outputs.tf                         # Root output values (VM Public IP, Application URL)
├── providers.tf                       # Terraform & AzureRM provider configuration
├── backend.tf                         # Azure Blob remote state backend definition
├── terraform.tfvars.example           # Example parameter values
├── .tflint.hcl                        # TFLint rules and module configuration
├── .gitignore                         # Git ignore rules for Terraform & secrets
└── README.md                          # Documentation
```

---

## 🚀 Quickstart: Step-by-Step Deployment

### Step 1: Create Backend Storage Account in Azure & Update `backend.tf`

Create your remote state storage manually in the Azure Portal or via Azure CLI:
1. Create a Resource Group (e.g. `rg-tfstate-pipeline`).
2. Create a Storage Account (e.g. `sttfstatepipeline`).
3. Create a Blob Container named `tfstate`.
4. Update [backend.tf](file:///c:/Users/mayan/.gemini/antigravity/scratch/azure-terraform-infra-pipeline/backend.tf) with your storage account details:
   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name  = "rg-tfstate-pipeline"
       storage_account_name = "<YOUR_STORAGE_ACCOUNT_NAME>"
       container_name       = "tfstate"
       key                  = "terraform.tfstate"
     }
   }
   ```

---

### Step 2: Configure GitHub Repository Secrets (App Registration)

Create an App Registration / Service Principal with `Contributor` role in Azure.
In your GitHub repository, navigate to:
**Settings** ➔ **Secrets and variables** ➔ **Actions** ➔ **New repository secret**

Add the 4 authentication secrets:

| Secret Name | Value Description |
| :--- | :--- |
| `AZURE_CLIENT_ID` | App Registration Client ID (`appId`) |
| `AZURE_CLIENT_SECRET` | App Registration Client Secret / Password |
| `AZURE_SUBSCRIPTION_ID` | Azure Subscription ID |
| `AZURE_TENANT_ID` | Azure Entra ID / Tenant ID |

---

### Step 3: Push Repository to GitHub

Create a new repository on GitHub, then run:

```bash
git remote add origin https://github.com/<YOUR-USERNAME>/<YOUR-REPO-NAME>.git
git branch -M main
git push -u origin main
```

---

### Step 4: Run CI/CD Pipeline in GitHub Actions

Once pushed to `main`:
1. Navigate to the **Actions** tab in your GitHub repository.
2. The **Terraform CD (Apply Infrastructure)** workflow triggers automatically on push to `main`.
3. You can also trigger it manually under **Actions** ➔ **Terraform CD** ➔ **Run workflow** (Options: `plan`, `apply`, `destroy`).
4. Any Pull Requests will automatically trigger the **Terraform CI (Validate & Plan)** workflow to run formatting, validation, and a speculative plan.

---

## 🌐 Accessing the Application

Once Terraform finishes applying, check the outputs:

```bash
Outputs:

application_url        = "http://20.102.x.x"
vm_public_ip           = "20.102.x.x"
vm_fqdn                = "myapp-dev-centralindia.centralindia.cloudapp.azure.com"
ssh_connection_command = "ssh azureuser@20.102.x.x"
```

Open `application_url` directly in your browser to view the application status dashboard and health endpoint (`/api/health`).

---

## 💻 Local Execution (Optional)

If you wish to run Terraform locally using your authenticated Azure CLI session:

```bash
# 1. Login to Azure
az login

# 2. Initialize with local state (or configure backend flags)
terraform init -backend=false

# 3. Create your terraform.tfvars
cp terraform.tfvars.example terraform.tfvars

# 4. Plan and Apply
terraform plan
terraform apply
```
