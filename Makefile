# A Self-Documenting Makefile: http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html

# Variables
BUILD_PATH = ./tmp
BIN_NAME = interpreter
MAIN_PATH = ./src/cmd/interpreter

.PHONY: install
install: ## Install/upgrade dependencies
	@echo ⬇️ Download project dependencies
	go mod download
	@echo ⬇️ Download air
	go install github.com/cosmtrek/air@latest

.PHONY: build
build: ## Build for Production
	go build -a -o ${BUILD_PATH}/${BIN_NAME}-prod -ldflags="-s -w" -gcflags=all="-l -B -C" ${MAIN_PATH}

.PHONY: build-dev
build-dev: ## Build for Development
	go build -o ${BUILD_PATH}/${BIN_NAME} ${MAIN_PATH}

.PHONY: run
run: ## Run app in dev mode
	go run ${MAIN_PATH}

.PHONY: dev
dev: ## Run in watch mode
	air -c .air.toml --build.bin ${BUILD_PATH}/${BIN_NAME}

.PHONY: test
test: ## Run tests
	go test -v ${MAIN_PATH}

# .PHONY: clear
# clear: ## Clear generated files
# 	rm -rf ${BUILD_PATH}

# Self-Documenting part
.PHONY: help
.DEFAULT_GOAL := help
help: ## Displays this help menu
	@grep -h -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "-> \033[36m%-20s\033[0m %s\n", $$1, $$2}'

