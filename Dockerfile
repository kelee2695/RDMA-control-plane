FROM golang:1.26.3 AS builder

WORKDIR /workspace
COPY go.mod ./
RUN go mod download
COPY cmd ./cmd

RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /rdma-control-plane ./cmd/manager

FROM ubuntu:24.04

LABEL org.opencontainers.image.source="https://github.com/kelee2695/rdma-control-plane"

COPY --from=builder /rdma-control-plane /usr/local/bin/rdma-control-plane

USER 65532:65532
ENTRYPOINT ["/usr/local/bin/rdma-control-plane"]
