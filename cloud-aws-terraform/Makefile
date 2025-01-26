PWD=$(shell pwd -L)
AWS_ACCOUNT=$(shell aws sts get-caller-identity --query Account --output text)
TF_TABLE="terraform-workload-lock"
TF_BUCKET="terraform-workload-data"
TZ=UTC

ifneq (,$(wildcard .env))
    include .env
    export
endif

all: help

create-policies-for-role:                       ## Create processed policies for role
	@echo "Creating policies for OIDC connection role in Amazon Web Services..."
	@rm -rf policies
	@mkdir -p policies
	@for policy in $(shell ls templates); do \
		cat templates/$${policy} | \
			sed "s/\$${account_id}/$(AWS_ACCOUNT)/g" | \
			sed "s/\$${bucket_id}/$(TF_BUCKET)/g" | \
			sed "s/\$${table_id}/$(TF_TABLE)/g" > policies/$${policy}; \
	done

help:                                           ## Display help screen
	@echo "Usage:"
	@echo "	 make [COMMAND]"
	@echo "	 make help \n"
	@echo "Commands: \n"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
