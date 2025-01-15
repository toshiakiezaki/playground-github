PWD=$(shell pwd -L)
AWS_CMD=aws
TZ=UTC

ifneq (,$(wildcard .env))
    include .env
    export
endif

.PHONY: all test vendor

all: help

help:                                          ## Display help screen
	@echo "Usage:"
	@echo "	 make [COMMAND]"
	@echo "	 make help \n"
	@echo "Commands: \n"
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
