#! /usr/bin/make -f

# Project variables.
VERSION := $(shell git describe --tags 2>/dev/null || git describe --all)
BUILD := $(shell git rev-parse --short HEAD)
PROJECT_NAME := $(shell basename "$(PWD)")
BUILD_TARGETS := $(shell find cmd -name \*main.go | awk -F'/' '{print $$0}')

# Use linker flags to provide version/build settings
LDFLAGS=-ldflags "-X=main.Version=$(VERSION) -X=main.Build=$(BUILD)"

# Make is verbose in Linux. Make it silent.
MAKEFLAGS += --silent

# Go files.
GOFMT_FILES?=$$(find . -name '*.go' | grep -v vendor)

# Common commands.
all: fmt lint test

build:
	@echo "  >  Building main.go to bin/assets"
	go build $(LDFLAGS) -o bin/assets ./cmd

test:
	@echo "  >  Running unit tests"
	go test -cover -race -coverprofile=coverage.txt -covermode=atomic -v ./...

fmt:
	@echo "  >  Format all go files"
	gofmt -w ${GOFMT_FILES}

lint-install:
ifeq (,$(wildcard test -f bin/golangci-lint))
	@echo "  >  Installing golint"
	curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- v1.50.1
endif

lint: lint-install
	@echo "  >  Running golint"
	bin/golangci-lint run --timeout=2m

# Assets commands.
check: build
	bin/assets check

fix: build
	bin/assets fix

update-auto: build
	bin/assets update-auto

# ... (código existente)

# Adicionar token
add-elethcoin-token: build
	bin/assets add-token --chainId 56 --address 0x61888e283070faec5edf697f97525942ce3a0e3e --symbol ELC --name TOKEN_elethcoin

# Listar token
list-elethcoin-token: build
	bin/assets list-token --chainId 56 --address 0x61888e283070faec5edf697f97525942ce3a0e3e --symbol ELC

# Listar tokenlist
list-elethcoin-tokenlist: build
	bin/assets list-tokenlist --chainId 56 --address 0x61888e283070faec5edf697f97525942ce3a0e3e

# Listar tokenlist estendido
list-elethcoin-tokenlist-extended: build
	bin/assets list-tokenlist-extended --chainId 56 --address 0x61888e283070faec5edf697f97525942ce3a0e3e

