# Architectural Decision Records

> Claude may **propose** entries here, but must not add them without human approval.

---

## ADR-001 — fenix for Rust toolchain instead of nixpkgs packages

- **Date**: 2025-01 (approx)
- **Status**: Accepted
- **Context**: `pkgs.rustc`, `pkgs.cargo`, etc. do not include `rust-src` in the sysroot. `rust-analyzer` needs stdlib sources via `rustc --print sysroot`, and without them it fails in GUI apps (VSCode) where env vars aren't inherited from the shell.
- **Decision**: Use `nix-community/fenix` flake input. Expose `pkgs-rust` via `extraSpecialArgs`. Use `pkgs-rust.stable.withComponents ["rustc" "cargo" "clippy" "rustfmt" "rust-src"]` + `pkgs-rust.rust-analyzer`.
- **Rationale**: fenix bundles `rust-src` directly into the sysroot, making `rust-analyzer` work identically in the terminal and in VSCode without extra env vars.
- **Trade-offs**: Extra flake input; slightly non-standard setup.

---

## ADR-002 — Pinned nixpkgs-go for Go 1.24 reproducibility

- **Date**: 2025-01 (approx)
- **Status**: Accepted
- **Context**: nixpkgs-unstable moves fast and can bump the Go version unexpectedly, breaking builds.
- **Decision**: Separate `nixpkgs-go` flake input pinned to a specific commit. Expose as `pkgs-go` via `extraSpecialArgs`. Use `pkgs-go.go_1_24` in `dev.nix`.
- **Rationale**: Go toolchain stability without freezing all other packages.
- **Trade-offs**: Must manually update the pin when upgrading Go intentionally.

---

## ADR-003 — nixpkgs-unstable as the main channel

- **Date**: 2025-01 (approx)
- **Status**: Accepted
- **Context**: Single-user workstation; rolling updates are acceptable. Stable nixpkgs often lags on tools like VSCode, Brave, etc.
- **Decision**: Use nixpkgs-unstable as the primary `nixpkgs` input.
- **Rationale**: Always-fresh packages with acceptable breakage risk for a personal machine.
- **Trade-offs**: Occasional build failures or behavioral changes after `nix flake update`.

---

## ADR-004 — bazel exposed as a writeShellScriptBin wrapper over bazelisk

- **Date**: 2025-01 (approx)
- **Status**: Accepted
- **Context**: Bazel version is managed per-project via `.bazelversion`. bazelisk reads that file and downloads the right version. Adding `pkgs.bazel` directly would install a fixed version that conflicts.
- **Decision**: `writeShellScriptBin "bazel"` that delegates to `bazelisk`. No `pkgs.bazelisk` directly in packages.
- **Rationale**: Per-project Bazel version management with a transparent `bazel` command.
- **Trade-offs**: bazelisk downloads Bazel on first use per version (network + disk).

---

## ADR-005 — ghostfolio over wealthfolio

- **Date**: 2026-03-07
- **Status**: Accepted
- **Context**: User switched portfolio tracker from wealthfolio (local Electron desktop app) to ghostfolio (self-hosted web app).
- **Decision**: Replace `pkgs.wealthfolio` with `pkgs.ghostfolio` in `home.nix`. Remove the `xdg.desktopEntries.wealthfolio` block — ghostfolio runs as a web server, not a desktop app.
- **Rationale**: User preference.
- **Trade-offs**: ghostfolio requires running a local server process; not as frictionless as a standalone desktop app.
