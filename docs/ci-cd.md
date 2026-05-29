# CI/CD

This repository uses GitHub Actions for Go validation and container image
publishing.

## Local commands

This project is pinned to Go `1.26.3`, matching the local development
environment. `make vet`, `make test`, and `make build` verify the active
toolchain before running.

Run the same checks locally before opening a pull request:

```sh
make fmt-check
make vet
make test
make test-smoke
make build
make image
```

## CI workflow

`.github/workflows/ci.yml` runs on pushes to `main`, pull requests, and manual dispatch.

It performs:

- Go formatting check
- `go vet`
- unit tests with race detector and coverage output
- manager binary build
- binary smoke test

## CD workflow

`.github/workflows/cd.yml` publishes a container image to GitHub Container
Registry.

It runs when pushing to `main`, pushing a semantic version tag, or starting the
workflow manually from GitHub Actions.

Published image format:

```text
ghcr.io/kelee2695/rdma-control-plane:<tag>
```

The image is built with a multi-stage Dockerfile:

- builder stage: `golang:1.26.3`
- runtime stage: `ubuntu:24.04`
- binary path: `/usr/local/bin/rdma-control-plane`

## Smoke tests

Smoke tests are black-box checks that run the built binary and verify externally
visible behavior. They are stored under `tests/smoke/` and can be implemented in
shell, Python, or any other tool that is available in CI.

The current smoke test runs `bin/rdma-control-plane`, verifies it exits
successfully, and checks its stdout.

Tags:

- `latest` for pushes to `main`
- the Git tag for `v*.*.*` releases
- `sha-<commit>` for every published image

## Next useful additions

- Add `golangci-lint` after the project has real code.
- Add Kubernetes manifest validation with `kubeconform` or `kubectl kustomize`.
- Add integration tests with `envtest` once controller-runtime is introduced.
- Add server deployment after the image is published.
