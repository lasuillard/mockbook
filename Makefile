#!/usr/bin/env -S make -f

MAKEFLAGS += --warn-undefined-variable
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --silent

SHELL := bash
.ONESHELL:
.SHELLFLAGS := -eu -o pipefail -c
.DELETE_ON_ERROR:
.DEFAULT_GOAL := help

help: Makefile  ## Show help
	@grep -E '(^[a-zA-Z_-]+:.*?##.*$$)|(^##)' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}' | sed -e 's/\[32m##/[33m/'


# =============================================================================
# Common
# =============================================================================
install:  ## Install deps
	git submodule update --init --recursive --remote
	pre-commit install --install-hooks
	uv python install
	uv sync --frozen
.PHONY: install

update:  ## Update deps and tools
	uv sync --upgrade
	pre-commit autoupdate
.PHONY: update

run:  ## Run full stack
	docker compose up --build
.PHONY: run

run-fastapi:  ## Run FastAPI server
	uv run --frozen uvicorn mockbook.main:app \
		--host "$$([ ! -z "$${CONTAINER:-}" ] && echo '0.0.0.0' || echo '127.0.0.1')" \
		--reload \
		--reload-dir ./mockbook \
		--reload-include '*.ipynb'
.PHONY: run-fastapi

run-jupyter:  ## Run Jupyter Lab
	uv run jupyter lab \
		--allow-root \
		--ip 0.0.0.0 \
		--ServerApp.root_dir ./mockbook \
		--NotebookApp.token=token
.PHONY: run-jupyter


# =============================================================================
# CI
# =============================================================================
ci: lint test  ## Run CI tasks
.PHONY: ci

format:  ## Run autoformatters
	pre-commit run --all-files shfmt
	pre-commit run --all-files ruff-format
.PHONY: format

lint:  ## Run all linters
	pre-commit run --all-files shellcheck
	pre-commit run --all-files ruff-check
	pre-commit run --all-files mypy
.PHONY: lint

test:  ## Run tests
	./test/bats/bin/bats --formatter pretty --verbose-run ./test
.PHONY: test
