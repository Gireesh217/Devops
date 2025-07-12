# Exercise 2 (SCPs, RCPs and Organization policies)

### Goal

Following on from the previous exercise, create the following resources via terraform:
- A resource control policy (rcp) that assigns the policy 'AmazonEC2FullAccess' to the EC2 instance previously created
- A service control policy (scp) that prevents EC2 instances from being assigned a public ip address
- An organization policy that disables serial port access on the virtual machines (EC2)

### Considerations

- Cost Management
- Redundancy
- Security
- Tagging