# Exercise 3 (Terraform best practices and modules)

### Goal

Following on from the previous exercise, implement the following:
- Migrate the EC2, VPC and subnets into individual terraform modules defined locally
- Ensure that variables are defined instead of static code values within terraform
  - Bonus points to those who explain through code comments, alternative methods to define resource values
- Create an S3 bucket and implement a remote state file within terraform using the bucket
  - Bonus points to those who implement Dynamo DB for state locking and consistency checking
- Deploy two instances of the terraform module creating an EC2 using a for-each loop and a count

### Considerations

- Cost Management
- Redundancy
- Security
- Tagging
