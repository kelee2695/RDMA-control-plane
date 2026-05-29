本项目用来学习 RDMA、Kubernetes 控制面和 Go 控制面开发。

## CI/CD 起步

当前仓库已经包含一个最小可用的 Go 项目骨架，以及 GitHub Actions 工作流：

- Go 版本以本机环境为准：`go1.26.3`。
- `.github/workflows/ci.yml`：PR 和 `main` 分支提交时运行格式检查、`go vet`、测试和构建。
- `Makefile`：把本地开发命令和 CI 命令统一起来。

本地验证：

```sh
make fmt-check
make vet
make test
make build
```

更多说明见 [docs/ci-cd.md](docs/ci-cd.md)。
