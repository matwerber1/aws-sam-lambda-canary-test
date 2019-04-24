# aws-sam-lambda-canary-test

## Purpose

The purpose of this project is to test AWS CodeDeploy's canary deployment method for a Lambda function. 

Using the AWS Serverless Application Model (SAM), we deploy a CloudFormation template that creates a Lambda function, CloudWatch alarms, and a CodeDeploy project. When a code change is made to the Lambda function and deployed via CloudFormation (or a SAM CLI deployment), a CodeDeploy project creates a new version of the Lambda with the new code and activates a canary deployment by which the "live" version alias of the Lambda function sends 10% of traffic to the new version and 90% of traffic to the old version. The two CloudWatch alarms monitor for errors with the new Lambda version and if errors are detected, the alarms trigger. If the alarms trigger, the CodeDeploy project managing the canary deployment rolls back the deployment by shifting 100% of traffic to the old, stable version of the Lambda. 

The Lambda is designed to intentionally throw an error if the input event contains **{ doFail: true }**; otherwise, the Lambda returns a success message. This allows us to deliberately test the canary deployment's rollback capability. 

The **test-function.sh** script invokes the Lambda function continuously in a loop with the **{ doFail: true }** input event and can be used to test the rollback feature when a canary deployment is in progress. 

## Prerequisites

* [AWS SAM CLI](https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/serverless-sam-cli-install.html)
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-macos.html)

## Usage

1. Within **deploy.sh**, edit parameters below as needed. The BUCKET should be changed to an S3 bucket that already exists and to which you have read/write access. This bucket is used to store packaged CloudFormation artifacts:

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