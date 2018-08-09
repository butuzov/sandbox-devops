# AWS ( and Terraform)

### Goal
Learn how and why to use terraform, while trying to figure out why to use AWS. Infrastructure -> VPC with public and private subnets, eip and LoadBalancer, NAT, Security groups etc...(common setup...)

```bash
terraform plan --var-file=../terraform.tfvars
terraform apply --var-file=../terraform.tfvars --auto-approve
terraform destroy --var-file=../terraform.tfvars --auto-approve
```

P.S.
EC2 provisioned via bash using Terraform.
