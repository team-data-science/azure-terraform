# Azure Setup

To start with the project get an Azure subcription. There is an option to get a free access for 1 month with 200 $ credits. Just take your Microsoft account or create one and follow this link:
https://azure.microsoft.com/en-us/pricing/purchase-options/azure-account.

To interact with your Azure subscription via the Terminal, we will be using the Azure CLI. It's needed to authenticate with your subscription to deploy infrastructure to it.
There is a documentation how to install the Azure CLI on: https://learn.microsoft.com/en-us/cli/azure/install-azure-cli.

For Mac users we recommend using homebrew and install the Azure CLI with
`brew update && brew install azure-cli`.

You can check if the installation was successful with
`az -v`.

# Setting up Terraform for Azure

The Azure provider in Terraform, known as azurerm, allows users to manage Azure resources through infrastructure as code. It integrates Terraform with Azure’s Resource Manager, enabling the provisioning, updating, and scaling of resources like virtual machines, storage accounts, and networking. It connects with Azure using eiter the Azure CLI, service principals, or managed identities for authentication. It simplifies managing Azure environments in a repeatable and automated way.

Install [Terraform Extension for VS Code](https://marketplace.visualstudio.com/items?itemName=4ops.terraform) to get syntax support for Terraform files.

We are using the [Azure Provider](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs) in Terraform to configure infrastructure in Azure. The documentation shows how to deploy specific resources and which parameters can be configured for each of them. Be careful that the version in the documentation matches the version you are using in the code (see provider.tf).

## Terraform project structure files

There are different ways to organize a terraform project. It's also possible to have everything written in a single file, which is obviously not the recommended way as it becomes hard to maintain, prone to errors, and challenging to scale as the complexity of your infrastructure grows.

The recommended project structure for a very simple project would be as described:

```
terraform-project/
│
├── main.tf             # Core resources and configurations
├── variables.tf        # Definitions of input variables
├── outputs.tf          # Output values for use in other modules or for reference
├── provider.tf         # Provider
├── terraform.tfvars    # Values for input variables (optional)
```

The files are including following contents:

- main.tf: All resources which have to be deployed, e.g. resource groups, storage accounts, azure data factory and key vaults
- variables.tf: Includes all variables which are used in the code to make the code more dynamically and general usable. This could include naming for resources, configuration settings, ids or environment settings.
- outputs.tf: This defines which values terraform should display after deployment as an information.
- provider.tf: This files holds the information which provider terraform should use with the version and authentication method.
- terraform.tfvars: This is an optional but very recommended file as it holds the values for the input variables defined in variables.tf. Otherwise you have to insert every value manually during the deployment.

## Terraform Commands

To use Terraform effectively, there are some common commands to help initialize, configure, apply, and manage your infrastructure throughout its lifecycle.

- `terraform init`: Sets up your Terraform environment by preparing the configuration directory to manage resources. It downloads and installs the necessary provider plugins and modules, such as the Azure provider, allowing Terraform to communicate with Azure services.
- `terraform plan`: Analyzes the current state of the infrastructure and the configuration code, showing what changes will occur without actually applying them. It’s used to review changes before making them live, giving you a safe preview.
- `terraform apply`: Creates or updates resources in the specified configuration. After reviewing the plan output, this command applies the changes, deploying or updating the infrastructure. Users confirm changes interactively unless an -auto-approve flag is added to skip prompts. The flag -var-file=terraform.tfvars uses the defined variables in the .tfvars-file to reduce manual input.
- `terraform destroy`: Destroys the resources managed by the configuration, removing the infrastructure created. It’s often used to clean up resources no longer needed or to start fresh with new configurations.
- `terraform validate`: Checks the syntax and validity of the configuration files without accessing any remote state or services. It’s a useful command to catch errors early in the development process.
- `terraform fmt`: Formats the code in the configuration files to a standardized structure for readability. This command aligns code to Terraform’s style conventions, making it easier to maintain and collaborate.

By initializing the project with `terraform init`, Terraform is generating the terraform.lock.hcl file to lock provider versions based on the specified configuration. This file ensures that every team member or automation process uses the same provider versions, preventing compatibility issues and maintaining consistent behavior across different environments.

## Terraform State

The tfstate file is essential in Terraform as it records the current state of your infrastructure, allowing Terraform to track existing resources and plan updates accurately. It is generated or updated every time you run commands like terraform apply, terraform refresh, or terraform destroy, ensuring Terraform has an up-to-date view of your infrastructure.

When not explicitly configured it uses the local project directory to save the .tfstate-file during the deployment process. There are some drawbacks of storing the Terraform State locally and better practices when developing in a team which we will discuss later in the course.

## Deployment of basic Azure resources for project setup

In this section, we define the provider settings in provider.tf, which is essential to connect Terraform with Azure. Let’s break down what each part of the configuration does:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}
```

The terraform block specifies Terraform's required providers and their versions, helping manage compatibility and ensuring consistent deployments. The pipe symbol in front of the version number indicates that it will use the latest version 4.x but will not automatically upgrade to version 5.x or beyond. This keeps the setup stable by avoiding breaking changes from major updates.

```
provider "azurerm" {
  features {}
}
```

The provider "azurerm" block configures settings specific to Azure, establishing Terraform’s connection to Azure’s API and configuring how it will deploy resources.

The empty features block is mandatory, even if no specific settings are defined within it. Azure’s provider requires this block, and it can later be expanded to specify additional settings, like configurations for certain Azure services.

### Authenticate with Azure CLI

To authenticate with Azure, open your Terminal or use the integrated terminal in Visual Studio Code. Enter the command `az login`. This action will launch your web browser, prompting you to log into your Azure account using your credentials. After logging in, the terminal will display a list of your subscriptions along with their corresponding IDs. Make sure to select the subscription you created for this course.

Once authenticated, Terraform will utilize this provider to manage resources within your Azure subscription. This ensures that your infrastructure as code (IaC) deployments are correctly targeted and executed in the desired environment, leveraging the capabilities of Azure’s cloud services.

Hint: Make sure your user has the right permissions in your subscription to create and manage resources.

### Define Terraform Variables

Certain resources in this Terraform project use variables to manage configurations like names, sizes, regions, and other settings. Variables help you create more modular, flexible code, allowing for easier updates and reuse in different environments.

To make use of variables and have them load automatically, we assign their values in a backend.tfvars file. For the backend setup, only two variables are used:

1. project_name: This variable sets the name of both the resource group and the storage account. Since Azure storage account names must be unique globally and contain only lowercase letters and numbers (and have to be between 3 and 24 characters), ensure the project_name value meets these requirements.
2. location: This variable specifies the Azure region where the storage account will be deployed.

By managing these values in backend.tfvars, you simplify configuration changes and reduce manual input, especially in different environments. Always double-check that your project_Terraform has been successfully initialized!name variable adheres to the storage account naming rules for a seamless deployment.

### Deployment steps

Open up your terminal and make sure you have the Terraform CLI installed. You can check your cli version by typing `terraform -v`. In the terminal you have to navigate to the backend-setup directory and run the command `terraform init` to initialize the terraform provider. This will download necessary provider plugins and prepare your environment for Terraform commands.

After executing the command you should see the output `Terraform has been successfully initialized!`. You see that terraform is creating a terraform.lock.hcl-file. This includes all dependencies and the provider version, which is used for the deployment to ensure dependency integrity. It locks the provider version and modules in the Terraform config to ensure consistency across different runs, even on different machines.

Note: Terraform no longer uses the subscription selected in the Azure CLI to determine the correct subscription, in order to avoid deployment errors. Instead, we need to specify the correct subscription_id directly in the code. While including the subscription_id in your code isn’t inherently a security risk, storing it in your codebase can expose it to unauthorized access. To mitigate this risk, we take advantage of environment variables for managing sensitive information securely.

To set the environment variable you can use the specific command based on your OS:

#### Windows

`set ARM_SUBSCRIPTION_ID = <your_subscription_id>`

#### macOS/Unix

`export ARM_SUBSCRIPTION_ID = <your_subscription_id>`

It's time consuming setting these variables manually during every terminal session. There are some other techniques to persist or set these values with more automation (we'll cover some of them later).

In the next step run `terraform validate` to ensure that the current configuration is correct and free of errors. After validation, use `terraform plan -var-file="backend.tfvars"` to review the deployment plan. This command will show a preview in the terminal of the resources Terraform will create, update, or delete. It will also generate a .tfstate file, which Terraform uses to track and store information about the actual state of deployed resources, enabling it to manage future changes effectively.

You will notice that the .tfstate file appears grayed out in the file explorer. This is because it is listed in the .gitignore file, which prevents it from being tracked by Git. The reason for this is that the .tfstate file can contain sensitive information about your deployed infrastructure, such as resource IDs, API keys, and other credentials. By excluding it from version control, you help protect this sensitive data from unauthorized access. It’s a best practice to ensure that such files remain confidential, especially when collaborating in teams or using public repositories.

The last step to make the final deploy is `terraform apply`. You can again pass values for the Terraform variables as in the plan command. When calling the .tfvars file `terraform.tfvars` Terraform includes it automatically without explicitely passing it in the command.

## Terraform modules

Terraform modules allow you to create reusable code blocks to ensure consistent environments and resources. It allows you to define which parameters of a service are needed to create the resources, enhancing the control over resources and reducing errors. Every module will have it's own main, variables and output file. Inside the variables are all parameters which are passed over to the module when calling it. During the `terraform init` the module will be loaded into the Terraform project.

A folder structure for a bigger Terraform project with multiple environments and modules could look like following:

````
terraform-project/
│
├── backend-setup/           # Folder for setting up the storage for Terraform state files
│   ├── main.tf              # Resources for object storage (e.g., Azure Storage Account)
│   ├── variables.tf         # Input variables for backend setup (e.g., storage account name)
│   ├── outputs.tf           # Outputs from the backend setup (e.g., storage account details)
│   ├── provider.tf          # Provider configurations for backend setup
│   ├── terraform.tfvars     # Values for input variables
│   ├── versions.tf          # Version constraints for Terraform and providers
│
├── main/                    # Main folder for the core project infrastructure
│   ├── main.tf              # Core infrastructure definitions (e.g., VMs, networking)
│   ├── variables.tf         # Input variables for core infrastructure
│   ├── outputs.tf           # Outputs for the main infrastructure
│   ├── provider.tf          # Provider configurations (uses backend storage for tfstate)
│   ├── terraform.tfvars     # Values for core input variables (e.g., environment-specific)
│   ├── versions.tf          # Version constraints for Terraform and providers
│
├── modules/                 # Reusable modules (if applicable)
│   ├── module1/
│   │   ├── main.tf              # Infrastructure definition of the module
│   │   ├── variables.tf         # Input variables for the parameters used inside the module
│   │   ├── outputs.tf           # Outputs from the module
│   ├── module2/
│   │   ├── main.tf              # Infrastructure definition of the module
│   │   ├── variables.tf         # Input variables for the parameters used inside the module
│   │   ├── outputs.tf           # Outputs from the module
│
├── environments/            # Environment-specific configurations (e.g., dev, prod)
│   ├── dev/
│   ├── prod/
│
├── terraform.tfvars         # Optional global tfvars for common values```
````
