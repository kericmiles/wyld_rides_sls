#!/bin/bash
set -eu

STAGE="${1:-dev}"
echo "Deploying static assets to ${STAGE}..."

BUCKET_NAME=$(aws \
    cloudformation describe-stacks \
    --stack-name "wild-rydes-${STAGE}" \
    --query "Stacks[0].Outputs[?OutputKey=='WebSiteBucket'] | [0].OutputValue" \
    --output text)

WEBSITE_URL=$(aws \
    cloudformation describe-stacks \
    --stack-name "wild-rydes-${STAGE}" \
    --query "Stacks[0].Outputs[?OutputKey=='WebSiteUrl'] | [0].OutputValue" \
    --output text)

aws s3 sync --acl 'public-read' --delete ./staticweb/ "s3://${BUCKET_NAME}/"

echo "Bucket URL: ${WEBSITE_URL}"
