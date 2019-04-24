#!/bin/bash

# After deploying a code change to the Lambda function, CodeDeploy should kick
# off a canary test for the function. After this starts, execute this script
# to intentionally and repeatedly invoke the canary Lambda function and
# trigger a failure. That should cause a rollback to occur. 

# When you run this, you should see that the ExecutedVersion should alternate
# between the new version (from your just-deployed function update) and the
# last successful version. The traffic split should be approximately 10% new
# and 90% old. 

STACK=aws-sam-lambda-canary-test
FUNCTION=$(
    aws cloudformation describe-stacks \
        --stack-name $STACK \
        --query 'Stacks[0].Outputs[?OutputKey==`FunctionName`].OutputValue' \
        --output text
)

for i in {1..600}
do
    DATE_WITH_TIME=`date "+%Y%m%d-%H%M%S"`
    echo Calling $FUNCTION at timestamp $DATE_WITH_TIME
    aws lambda invoke \
        --function-name $FUNCTION \
        --payload "{ \"doFail\": true }" \
        --qualifier live \
        invoke-output.fail
    sleep 1
done


