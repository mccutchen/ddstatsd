#!/bin/bash

set -e
set -u

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_VERSION=$(awk '/const VERSION/ {print $NF}' < main.go | sed 's/"//g')
GO_VERSION=$(go version | awk '{print $3}')

echo "running tests"
make test

mkdir -p dist

for TARGET in "linux/amd64" "linux/arm64"; do
    OS=${TARGET%/*}
    ARCH=${TARGET##*/}

    echo
    echo "building v${BIN_VERSION} for $OS/$ARCH"

    BIN_NAME="ddstatsd-$BIN_VERSION.$OS-$ARCH.$GO_VERSION"
    BUILD_DIR=$(mktemp -d ${TMPDIR:-/tmp}/ddstatsd-XXXXX)
    GOOS=$OS GOARCH=$ARCH CGO_ENABLED=0 BIN_NAME=$BIN_NAME BUILD_DIR=$BUILD_DIR make dist

    rm -rf $BUILD_DIR
done
