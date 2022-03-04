## Infrastructure Test

With the following terraform code will created:


* Resource Group
* Virtual Network
* Subnet
* Public IP Address
* Network Security Group
* Virtual Network Interface
* Virtual Machine


### Steps

1. Configure your environment

* Azure subscription
* Configure Terraform [Azure Documentation](https://docs.microsoft.com/en-us/azure/developer/terraform/get-started-cloud-shell-bash?tabs=bash)

2. Terraform code

* Create a directory in which to test the Terraform code

3. Run Terraform

`terraform init`

`terraform plan`

`terraform apply`

**terraform init** initialize the Terraform deployment. This command downloads the Azure modules required to manage your Azure resources.

**terraform plan** creates an execution plan, but doesn't execute it. Instead, it determines what actions are necessary to create the configuration specified in your configuration files. 
This pattern allows you to verify whether the execution plan matches your expectations before making any changes to actual resources.

**terraform apply** apply the execution plan to your cloud infrastructure.
