#!/bin/sh
set -eu

bin="${1:-bin/rdma-control-plane}"
want="rdma-control-plane manager starting"

if [ ! -x "$bin" ]; then
	echo "binary is not executable: $bin" >&2
	exit 1
fi

got="$("$bin")"

if [ "$got" != "$want" ]; then
	echo "unexpected output" >&2
	echo "got:  $got" >&2
	echo "want: $want" >&2
	exit 1
fi

echo "smoke test passed: $bin"
