APP := rdma-control-plane
PKG := ./...
BIN_DIR := bin
IMAGE ?= ghcr.io/kelee2695/rdma-control-plane:dev
GO_VERSION := 1.26.3

.PHONY: help
help:
	@printf "Targets:\n"
	@printf "  fmt         Format Go code\n"
	@printf "  fmt-check   Verify Go formatting\n"
	@printf "  vet         Run go vet\n"
	@printf "  test        Run unit tests\n"
	@printf "  build       Build local binary\n"
	@printf "  image       Build container image\n"
	@printf "  check-go-version Verify local Go version\n"

.PHONY: fmt
fmt: check-go-version check-gofmt
	gofmt -w $$(find . -name '*.go' -not -path './vendor/*')

.PHONY: fmt-check
fmt-check: check-go-version check-gofmt
	@test -z "$$(gofmt -l $$(find . -name '*.go' -not -path './vendor/*'))"

.PHONY: vet
vet: check-go-version
	go vet $(PKG)

.PHONY: test
test: check-go-version
	go test -race -coverprofile=coverage.out $(PKG)

.PHONY: build
build: check-go-version
	mkdir -p $(BIN_DIR)
	go build -o $(BIN_DIR)/$(APP) ./cmd/manager

.PHONY: image
image:
	docker build -t $(IMAGE) .

.PHONY: check-go
check-go:
	@command -v go >/dev/null || { echo "go is required but was not found in PATH"; exit 1; }

.PHONY: check-go-version
check-go-version: check-go
	@actual="$$(go env GOVERSION)"; expected="go$(GO_VERSION)"; \
	if [ "$$actual" != "$$expected" ]; then \
		echo "Go $$expected is required (found $$actual)"; \
		exit 1; \
	fi

.PHONY: check-gofmt
check-gofmt:
	@command -v gofmt >/dev/null || { echo "gofmt is required but was not found in PATH"; exit 1; }
