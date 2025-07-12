```
<pre>
This is a code block without syntax highlighting.
It will display exactly as typed, without any color.
</pre>

This project structure is designed to manage AWS security resources using Terraform in a modular and environment-specific way. It includes global configurations for IAM roles, policies, and AWS Organizations, along with reusable service modules for AWS Services. 
The environments/ folder contains configuration files tailored for the dev environment, where you can customize settings for different services like EC2, S3, and EKS. 
Additionally, the modules/ directory provides reusable Terraform modules for provisioning and securing AWS resources, while the examples/ folder offers sample configurations to demonstrate module usage.

terraform-aws-security/
├── global/                         # Global security resources (IAM, Organizations etc.)
│   ├── iam/                        # IAM resources (roles, policies, groups, usergroups)
│   │   ├── users/                  # Individual IAM Users (rare, usually federated)
│   │   ├── user-groups/            # Individual IAM User Groups
│   │   ├── roles/                  # IAM roles for EC2 & Lambda services
│   │   ├── policies/               # IAM Policies
│   │   │   ├── s3/                 # S3 Policies
│   │   │   ├── ec2/                # EC2 Policies
│   │   │   ├── eks/                # EKS Policies
│   ├── organizations/
│   │   ├── security-category-1/
│   │   ├── security-category-2/
│   ├── main.tf                     # Global resources main configuration file
│   ├── variables.tf                # Global resources variables definition file
│   ├── outputs.tf                  # Global resources outputs file
│   └── README.md
├── environments/                   # Environment-specific configurations
│   ├── dev/                        # Dev environment configurations
├── modules/                        # Reusable modules for AWS services
│   ├── ec2/                        # Module to create EC2 instances with security best practices
│   ├── s3/                         # Module to create S3 buckets with security configurations
│   ├── eks/                        # Module to create EKS clusters
├── examples/                       # Examples of how to use the modules
├── README.md                       # Project-level README


**1. Global**
This folder contains security resources that apply globally across all environments. These include IAM roles, policies, user groups, AWS Organizations configurations, and other foundational resources.

> iam/: Contains IAM-related configurations for users, user groups, roles, and policies.
    > users/: Defines individual IAM users (though federated access is usually preferred).
    > user-groups/: Defines IAM user groups, used for managing users permissions.
    > roles/: Defines roles, typically for EC2, Lambda, and other AWS services.
    > policies/: Defines IAM policies categorized by AWS services (e.g., S3, EC2, EKS).

> organizations/: Defines configurations for AWS Organizations (if used), such as Service Control Policies (SCPs) and account structure.
> main.tf:  The main configuration file that ties all global security resources together.
> variables.tf: Defines variables for global security resources.
> outputs.tf: Specifies outputs for global resources.
> README.md: Provides documentation on the global resources and their usage.


**2. Environments**
This folder contains environment-specific configurations, ensuring that resources are tailored for different stages (e.g., Dev, Test, Prod).

> dev/, test/, prod/: Each of these folders corresponds to a different environment. Each environment folder contains:
    > terraform.tfvars: Defines environment-specific variables, such as region, instance types, or other environment-specific configurations.
    > Service-specific folders (e.g., ec2/, s3/, eks/): These contain the environment-specific configurations for the corresponding AWS services (EC2, S3, EKS, etc.).
        > main.tf: The main configuration for the service in this environment.
        > variables.tf: Variables specific to the service in the environment.
        > outputs.tf: Outputs for the service resources in the environment.

**3. Modules**
This folder contains reusable Terraform modules that can be used across various environments or projects. Each module is focused on a single AWS service or security best practice.

> ec2/: Defines the module for provisioning EC2 instances with security best practices.
> s3/: Defines the module for provisioning S3 buckets with security configurations.
> eks/: Defines the module for provisioning EKS clusters with security best practices.
> Each module contains:
    > main.tf: The main configuration for provisioning resources of the service.
    > variables.tf: Variables for configuring the resources.
    > outputs.tf: Outputs from the created resources.
    > config.tf: Service-specific configurations for fine-tuning resources.
    > README.md: Documentation for the module.

**4. Examples**
This folder provides example configurations demonstrating how to use the reusable modules from the modules/ directory. Each example shows how to integrate the module into different environments.

> s3/, ec2/, eks/: Example configurations for provisioning S3, EC2, and EKS resources using the respective modules.
    > main.tf: The main Terraform configuration file for the example.
    > variables.tf: Example variable definitions for the resources.
    > outputs.tf: Example outputs from the created resources.
    > config.tf: Configuration file to modify the module's behavior.
    > README.md: Provides instructions on how to use the example.       
    
```
