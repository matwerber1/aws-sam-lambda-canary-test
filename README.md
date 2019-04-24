# aws-sam-lambda-canary-test

## Prerequisites

* AWS SAM CLI
* AWS CLI

## Usage

1. Within **deploy.sh**, edit parameters below as needed. The BUCKET should be an S3 bucket that can be used to store packaged CloudFormation artifacts:

```sh
BUCKET=werberm-sandbox
REGION=us-east-1
STACK=aws-sam-lambda-canary-test
```

2. Deploy template.yaml to CloudFormation:

```sh
./deploy.sh
```

3. Make a small, trivial edit to **hello-world/app.js**, then re-run the **./deploy.sh** script. This will trigger a canary deployment (you can verify by going to the CodeDeploy console).

4. While the canary deployment is underway, you can start sending invocations to the original and canary Lambda version by running **./test-function.sh**. 