# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this repo is

Declarative home-manager configuration for a single Ubuntu x86_64 user (`marcodellemarche`). There is no NixOS system config — only home-manager in standalone mode.

## Key commands

```sh
# Apply configuration (subsequent runs — uses the home-reload alias once zsh is active)
home-manager switch --flake ~/nix/#$USER

# First-time apply (before home-manager is in PATH)
nix run nixpkgs#home-manager -- switch --flake ~/nix/#$USER

# Update all flake inputs
nix flake update ~/nix

# List generations / roll back
home-manager generations
home-manager rollback
```

> **Important:** Nix flakes only include git-tracked files. Run `git add` on any new `.nix` files or config files before running `home-manager switch`, or the build will fail with "path does not exist".

## Architecture

Entry point: `flake.nix` → `home-manager/home.nix` → `home-manager/apps/*.nix`

**`flake.nix`**
- `nixpkgs` input: nixpkgs-unstable (rolling)
- `nixpkgs-go` input: pinned to a specific commit for Go 1.24 reproducibility
- `pkgs-go` is passed as `extraSpecialArgs` — available as a module parameter in any `apps/*.nix` file

**`home-manager/home.nix`** — slim orchestrator
- Identity (`username`, `homeDirectory`, `stateVersion`)
- Fonts, cursor, `sessionPath`
- Desktop app packages (slack, brave, vscode, obsidian) + JetBrains Mono Nerd Font
- `xdg.desktopEntries` for sandbox-mode GUI apps

**`home-manager/apps/`** — one file per concern
| File | Owns |
|------|------|
| `zsh.nix` | zsh, oh-my-zsh, p10k, fzf, eza, zoxide, shell aliases |
| `git.nix` | git settings, LFS, aliases, merge tool |
| `dev.nix` | all CLI/dev packages + bazel wrapper |
| `tmux.nix` | tmux with resurrect/continuum, vi keys |
| `ssh.nix` | placeholder (disabled — `~/.ssh/config` is managed by coder) |

**`home-manager/config/p10k.zsh`** — deployed via `home.file.".p10k.zsh".source`

## Important patterns

**Bazel:** exposed via a `writeShellScriptBin "bazel"` wrapper that delegates to `bazelisk`. Do not add `pkgs.bazelisk` directly to packages.

**Go version:** use `pkgs-go.go_1_24` (not `pkgs.go`). The `pkgs-go` arg is only available in modules that receive it — `dev.nix` already has it in its parameter list.

**Unfree packages:** `nixpkgs.config.allowUnfree = true` is set in `home.nix`. No per-package override needed.

**SSH config:** `~/.ssh/config` is not managed by home-manager (coder auto-writes into it). Don't enable `programs.ssh` without first handling the coder-managed sections.

**New files:** must be `git add`ed before they're visible to the flake evaluator.
