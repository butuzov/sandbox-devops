# Lambda

This Lambda function will create ami for ec2 instances with tag `backup`, it will use valued of tag `Name`.
It also will delete older ami backups, including snapshots (setup rate by yourself in cloudformation template).

# AWS Lambda Usage Example

This is a example of lambda deployment to aws using cloudformation.

1) Change s3 bucket I used  (butuzov-lambdas)
2) Upload Lambda manually
3) Upload CloudFormation
4) Congrats!

or just type in terminal `./deployment.sh`
