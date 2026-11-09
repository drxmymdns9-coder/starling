#!/usr/bin/env bash
set -euo pipefail

if [[ -f "$HOME/.cargo/env" ]]; then
  # shellcheck disable=SC1090
  source "$HOME/.cargo/env"
fi

rustup target add aarch64-apple-ios
cargo build --release --locked --no-default-features \
  -p horizon-ios \
  --target aarch64-apple-ios

LIB="target/aarch64-apple-ios/release/libhorizon_ios.a"
if [[ ! -f "$LIB" ]]; then
  echo "Rust iOS static library was not produced: $LIB" >&2
  exit 1
fi

echo "Built $LIB"
