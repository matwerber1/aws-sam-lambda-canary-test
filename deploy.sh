BUCKET=werberm-sandbox
REGION=us-east-1
STACK=aws-sam-lambda-canary-test

sam package \
    --output-template-file packaged.yaml \
    --s3-bucket $BUCKET

sam deploy \
    --template-file packaged.yaml \
    --stack-name $STACK \
    --capabilities CAPABILITY_IAM \
    --region $REGION