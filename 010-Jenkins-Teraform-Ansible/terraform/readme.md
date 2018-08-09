# Terraform with AWS

Exporting Access and Secret Keys for terraform

```bash
export TF_VAR_AWS_ACCESS_KEY="APIAIPNFUCKUALOAWUDAQ"
export TF_VAR_AWS_SECRET_KEY="9b+HwaV51t_d0sNt_VvORK_0_l0l_uULZ4s3teS9U9"
```

Running Terraform.

```bash
terraform init
terraform plan
terraform apply --auto-approve

# Delete setup when ready
terraform destroy --auto-approve
```
## Technical

4 nodes - services ( https://ci.made.ua , https://artifactory.made.ua/artifactory and https://registry.made.ua:5000/v2 ) and slave (http://host.made.ua or 18.194.137.154)

## Deployments
(this ips now expired, and was mapped to domain only during getting grades for work)

* QA [18.194.137.154:8092](http://18.194.137.154:8092)
* Dev [18.194.137.154:8091](http://18.194.137.154:8091)
* Prod [18.194.137.154:8090](http://18.194.137.154:8090)

##
