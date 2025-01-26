PWD=$(shell pwd -L)
AWS_ACCOUNT=$(shell aws sts get-caller-identity --query Account --output text)
AWS_REGION="us-east-1"
TF_TABLE="terraform-workload-lock"
TF_BUCKET="terraform-workload-data"
TZ=UTC

ifneq (,$(wildcard .env))
    include .env
    export
endif

all: help

process-policy-variables:                       ## Process variables in policies
	@echo "Processing variables in policies for GitHub Actions role in Amazon Web Services..."
	@rm -rf policies
	@mkdir -p policies
	@for policy in $(shell ls templates); do \
		cat templates/$${policy} | \
			sed "s/\$${account_id}/$(AWS_ACCOUNT)/g" | \
			sed "s/\$${region_id}/$(AWS_REGION)/g" | \
			sed "s/\$${bucket_id}/$(TF_BUCKET)/g" | \
			sed "s/\$${table_id}/$(TF_TABLE)/g" > policies/$${policy}; \
	done

create-terraform-policy:                        ## Create terraform policy
	@echo "Creating terraform policy for GitHub Actions role in Amazon Web Services..."
	@aws iam create-policy --policy-name github-actions-terraform-policy --policy-document file://policies/github-actions-terraform-policy.json

create-terraform-bucket:                        ## Create terraform workload bucket
	@echo "Creating terraform bucket to store workload data in Amazon Web Services..."
	@aws s3api create-bucket --region $(AWS_REGION) --bucket $(TF_BUCKET) --no-object-lock-enabled-for-bucket
	@aws s3api put-bucket-versioning --region $(AWS_REGION) --bucket $(TF_BUCKET) --versioning-configuration Status=Enabled
	@aws s3api put-bucket-encryption --region $(AWS_REGION) --bucket $(TF_BUCKET) --server-side-encryption-configuration '{ "Rules": [ { "ApplyServerSideEncryptionByDefault": { "SSEAlgorithm": "AES256" }, "BucketKeyEnabled": true } ] }'

help:                                           ## Display help screen
	@echo "Usage:"
	@echo "	 make [COMMAND]"
	@echo "	 make help \n"
	@echo "Commands: \n"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
