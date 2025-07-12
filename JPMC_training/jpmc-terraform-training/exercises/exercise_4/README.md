# Exercise 4 (Justfile, workflows and hooks)

### Goal

Following on from the previous exercise, implement the following:
- Write a Just file that has functions to:
  - simplify re-authenticating to AWS
  - format all terraform files in the repository
- Create an S3 bucket via the console and import this into state file through the terraform configuration
- Create a pre commit hook to format and lint terraform
- Create a deployment pipeline that executes the terraform deployment with the repository values below:
  - AWS_ACCESS_KEY_ID
  - AWS_SECRET_ACCESS_KEY
  - AWS_DEFAULT_REGION

### Considerations

- Cost Management
- Redundancy
- Security
- Tagging