# Calling Lambda with Custom Domain (with custom basepathmapping)

Case: Using few different aws accounts to deploy domain in gateway api to be used with lambda.

```
serverless deploy --stage=beta --region=us-west-2
```

This example solve one issue with dinamicaly created `AWS::ApiGateway::BasePathMapping` that comes with no `Stage`. See more info at https://github.com/serverless/serverless/issues/4029

Correct execution order and resources will be  `Lambda` -> (`Domain & RestApi`) -> `Deployment` -> `BasePathMapping`. Serverless will create **2** deployments - own real and our fake, but will need to wait till fake is ready to create `BasePathMapping` and basepathpadding will have stage at this step of execution.


### Route 53
This is solution for a problem that use few different aws acconts and all domains managed just from one of them. So... Route53 not included.
