PWD=$(shell pwd -L)
GCP_PROJECT_ID=$(shell gcloud config get-value project)
GCP_PROJECT_NUMBER=$(shell gcloud projects describe $(GCP_PROJECT_ID) --format='value(projectNumber)')
TZ=UTC

ifneq (,$(wildcard .env))
    include .env
    export
endif

.PHONY: all test vendor

all: help

create-identity-pool:                          ## Create workload identity pool
	@echo "Creating workload identity pool in Google Cloud Platform..."
	@gcloud iam workload-identity-pools create github-actions-pool --location="global"
		--display-name="GitHub Actions Pool" --description="Workload identity pool for GitHub Actions"
		--project $(GCP_PROJECT_ID)

create-identity-pool-provider:                 ## Create workload identity pool provider with OIDC
	@echo "Creating workload identity pool provider with OIDC in Google Cloud Platform..."
	@gcloud iam workload-identity-pools providers create-oidc github-actions-oidc-provider \
		--location="global" --workload-identity-pool="github-actions-pool"  \
		--issuer-uri="https://token.actions.githubusercontent.com" \
		--attribute-mapping="attribute.actor=assertion.actor,google.subject=assertion.sub,attribute.repository=assertion.repository" \
		--attribute-condition="assertion.repository_owner=='toshiakiezaki'" \
		--display-name "GitHub Actions OIDC Provider"
		--project $(GCP_PROJECT_ID)

create-service-account:                        ## Create service account
	@echo "Creating service account in Google Cloud Platform..."
	@gcloud iam service-accounts create github-actions \
		--display-name="Service account used by all workflows in GitHub Actions" \
		--project $(GCP_PROJECT_ID)

# gcloud projects add-iam-policy-binding $(GCP_PROJECT_ID) \
#   --member='serviceAccount:github-actions@$(GCP_PROJECT_ID).iam.gserviceaccount.com' \
#   --role="roles/compute.viewer"

# gcloud iam service-accounts add-iam-policy-binding github-actions@$(GCP_PROJECT_ID).iam.gserviceaccount.com \
#   --project=$(GCP_PROJECT_ID) \
#   --role="roles/iam.workloadIdentityUser" \
#   --member="principalSet://iam.googleapis.com/projects/$(GCP_PROJECT_NUMBER)/locations/global/workloadIdentityPools/github-actions-pool/attribute.repository/toshiakiezaki/*"

help:                                          ## Display help screen
	@echo "Usage:"
	@echo "	 make [COMMAND]"
	@echo "	 make help \n"
	@echo "Commands: \n"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
