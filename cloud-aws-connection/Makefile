PWD=$(shell pwd -L)
AWS_ACCOUNT=$(shell aws sts get-caller-identity --query Account --output text)
TZ=UTC

ifneq (,$(wildcard .env))
    include .env
    export
endif

.PHONY: all test vendor

all: help

create-policies-for-role:   					## Create processed policies for role
	@echo "Creating policies for OIDC connection role in Amazon Web Services..."
	@rm -rf policies
	@mkdir -p policies
	@for policy in $(shell ls templates); do \
		sed	"s/\$${account_id}/$(AWS_ACCOUNT)/g" templates/$${policy} > policies/$${policy}; \
	done

create-connection-provider:                    ## Create OIDC connection provider
	@echo "Creating OIDC connection provider in Amazon Web Services..."
	@aws iam create-open-id-connect-provider --url "https://token.actions.githubusercontent.com" --thumbprint-list "6938fd4d98bab03faadb97b34396831e3780aea1" --client-id-list "sts.amazonaws.com"

create-connection-role:                        ## Create OIDC connection role
	@echo "Creating connection role in Amazon Web Services..."
	@aws iam create-role --role-name "github-actions-role" --assume-role-policy-document file://policies/github-assume-role.json

help:                                          ## Display help screen
	@echo "Usage:"
	@echo "	 make [COMMAND]"
	@echo "	 make help \n"
	@echo "Commands: \n"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
