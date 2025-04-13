# A Self-Documenting Makefile: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

# Variables
BUILD_PATH = ./tmp
BIN_NAME = main

.PHONY: install
install: ## Install/upgrade dependencies
	@echo ⬇️ Download project dependencies
	go mod download
	@echo ⬇️ Download air
	go install github.com/air-verse/air@latest

.PHONY: build
build: ## Build for Production
	go build -a -o ${BUILD_PATH}/${BIN_NAME}-prod -ldflags="-s -w" -gcflags=all="-l -B -C" ./src/cmd/interpreter

.PHONY: build-dev
build-dev: ## Build for Development
	go build -o ${BUILD_PATH}/${BIN_NAME} ./src/cmd/interpreter

.PHONY: run
run: ## Run the executable
	${BUILD_PATH}/${BIN_NAME}

.PHONY: dev
dev: ## Run in Development mode
	air --build.bin ${BUILD_PATH}/${BIN_NAME}

.PHONY: test
test: ## Run test command
	go test -v ./src/cmd/interpreter

# .PHONY: clear
# clear: ## Clear generated files
# 	rm -rf ${BUILD_PATH}

# Self-Documenting part
.PHONY: help
.DEFAULT_GOAL := help
help: ## Displays this help menu
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "-> \033[36m%-20s\033[0m %s\n", $$1, $$2}'
