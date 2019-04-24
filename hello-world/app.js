exports.lambdaHandler = async (event, context) => {

    console.log(`Function: ${process.env.AWS_LAMBDA_FUNCTION_NAME}`)
    console.log(`Version: ${process.env.AWS_LAMBDA_FUNCTION_VERSION}`)
    console.log(`Log Group: ${process.env.AWS_LAMBDA_LOG_GROUP_NAME}`)
    console.log(`Log Stream: ${process.env.AWS_LAMBDA_LOG_STREAM_NAME}`)

    // Edit the log line below to some arbitrary value just so that the change
    // gets picked up and triggers a CodeDeploy canary deployment.
    console.log('....')
    
    if (event.doFail === true) {
        throw new Error(`ERROR: Function version ${process.env.AWS_LAMBDA_FUNCTION_VERSION} intentionally threw error based on input event containing doFail = true.`)            
    } else {
        return `Function version ${process.env.AWS_LAMBDA_FUNCTION_VERSION} success.`;
    }
};
