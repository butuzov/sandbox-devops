#!/usr/bin/env bash

function lambda(){
    local counter=$1
    # cleanup
    while read -d '' -r file; do
        out=$(diff -d $file "lambda-${counter}.zip")
        if [[ ! -z $out ]]; then
            unlink $file
        fi
    done < <(find . -name "lambda-*" -print0)

}

CREATE_LAMBDA="Yes"

counter=$(cat .number)
counter=$((counter + 1))
echo $counter > .number

zip "lambda-${counter}" lambda.py 2>&1 >/dev/null

if [[ ! -z $CREATE_LAMBDA ]]; then
    # ship new version
    aws s3 mv "lambda-${counter}.zip" "s3://butuzov-lambdas/lambda-${counter}.zip"
    sed -e "s/lambda.zip/lambda-${counter}.zip/" ec2amis_backup.yaml > deployment.yml
else
    # zip any new version
    aws s3 mv "lambda-${counter}.zip" "s3://butuzov-lambdas/lambda.zip"
        # date = time.strftime('%Y-%m-%d', time.strptime("29 Nov 00", "%d %b %y") )
    cp ec2amis_backup.yaml deployment.yml
fi

exists=$(aws cloudformation list-stacks --stack-status-filter "CREATE_IN_PROGRESS" "CREATE_COMPLETE" "UPDATE_COMPLETE_CLEANUP_IN_PROGRESS" "UPDATE_COMPLETE" | grep "demo")

if [[ ! -z $exists ]]; then
    action=update-stack
else
    action=create-stack
fi

aws cloudformation $action --stack-name demo --template-body "file://$(pwd)/deployment.yml" --capabilities CAPABILITY_NAMED_IAM

sleep 10

unlink deployment.yml
