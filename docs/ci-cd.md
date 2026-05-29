# CI

This repository uses GitHub Actions for basic Go validation.

## Local commands

This project is pinned to Go `1.26.3`, matching the local development
environment. `make vet`, `make test`, and `make build` verify the active
toolchain before running.

Run the same checks locally before opening a pull request:

```sh
make fmt-check
make vet
make test
make build
```

## CI workflow

`.github/workflows/ci.yml` runs on pushes to `main`, pull requests, and manual dispatch.

It performs:

- Go formatting check
- `go vet`
- unit tests with race detector and coverage output
- manager binary build

## Next useful additions

- Add `golangci-lint` after the project has real code.
- Add Kubernetes manifest validation with `kubeconform` or `kubectl kustomize`.
- Add integration tests with `envtest` once controller-runtime is introduced.
