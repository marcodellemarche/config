# nix — Claude Briefing

> This file is the first thing Claude reads at the start of every session.
> **Only the human should modify this file.**

---

## What is this project

Declarative home-manager configuration for a single Ubuntu x86_64 user (`marcodellemarche`). No NixOS system config — standalone home-manager only. The repo lives at `~/nix`, remote: `github.com:marcodellemarche/config.git`.

---

## Stack & technical constraints

- Nix flakes + home-manager (standalone mode, not a NixOS module)
- `nixpkgs` input: nixpkgs-unstable (rolling)
- `nixpkgs-go`: pinned commit for Go 1.24 reproducibility
- `fenix`: nix-community/fenix for Rust toolchains
- Ubuntu x86_64 — no NixOS, no Darwin
- `nixpkgs.config.allowUnfree = true` set globally — no per-package overrides needed

---

## How to start every session

1. Read this file fully
2. Read `.claude/CONTEXT.md`
3. Confirm understanding: summarize current state and ask "What do you want to work on this session?"
4. Work on **one objective per session** — if the scope expands, flag it and ask

---

## Operational rules (always enforce)

- **One task per session.** Do not start a second objective without explicit confirmation.
- **2-attempt rule.** If a problem isn't solved after 2 attempts, stop. Describe what you tried and why it didn't work. Do not keep iterating blindly.
- **Checkpoint every ~10 exchanges.** Pause and ask: "Am I still heading in the right direction?"
- **When in doubt, ask.** Never assume intent on architectural or structural decisions.
- **No gold-plating.** Don't improve things that weren't asked. Stay in scope.

---

## File ownership

Claude **may** update autonomously:

- `.claude/CONTEXT.md` — at the end of every productive session
- `.claude/ERRORS.md` — whenever a significant mistake or wasted effort occurs
- `.claude/TASKS.md` — task status during active work
- `README.md` — operational notes, instructions, and reference for the human. Claude may add instructions or notes here for the human's benefit, but must not change any of the existing content without explicit approval.

Claude **must never** modify autonomously:

- `CLAUDE.md` — human-only
- `.claude/DECISIONS.md` — human approval required (Claude may *propose* an ADR, but not add it unilaterally)

---

## Key commands

```sh
# Apply configuration
nix run nixpkgs#home-manager -- switch --flake ~/nix/#$USER

# Update all flake inputs
nix flake update ~/nix

# List generations / roll back
nix run nixpkgs#home-manager -- generations
nix run nixpkgs#home-manager -- rollback
```

> **Critical:** Nix flakes only include git-tracked files. Run `git add` on any new `.nix` files before `home-manager switch`, or the build will fail with "path does not exist".

---

## Architecture

Entry point: `flake.nix` → `home-manager/home.nix` → `home-manager/apps/*.nix`

**`flake.nix`**

- `nixpkgs` input: nixpkgs-unstable
- `nixpkgs-go` input: pinned commit for Go 1.24 reproducibility
- `fenix` input: nix-community/fenix for Rust toolchains
- `pkgs-go` and `pkgs-rust` passed as `extraSpecialArgs` — available as module parameters in any `apps/*.nix`

**`home-manager/home.nix`** — slim orchestrator

- Identity (`username`, `homeDirectory`, `stateVersion`)
- Fonts, cursor, `sessionPath`
- Desktop app packages (slack, brave, vscode, obsidian, ghostfolio) + JetBrains Mono Nerd Font
- `xdg.desktopEntries` for sandbox-mode GUI apps
- `xdg.mimeApps` — Brave as default browser

**`home-manager/apps/`** — one file per concern

| File | Owns |
|------|------|
| `zsh.nix` | zsh, oh-my-zsh, p10k, fzf, eza, zoxide, shell aliases |
| `git.nix` | git settings, LFS, aliases, merge tool, commit signing |
| `dev.nix` | all CLI/dev packages + bazel wrapper |
| `tmux.nix` | tmux with resurrect/continuum, vi keys |
| `ssh.nix` | SSH static hosts in matchBlocks + Include for coder |
| `gpg.nix` | GPG keyring, gpg-agent with pinentry-gnome3 |

**`home-manager/config/p10k.zsh`** — deployed via `home.file.".p10k.zsh".source`

---

## Known anti-patterns

**home-manager is never in Claude's PATH.**
Always use `nix run nixpkgs#home-manager -- switch --flake ~/nix/#$USER`. Never try the bare `home-manager` command first.

**`~/.config/mimeapps.list` will always conflict.**
GNOME and desktop apps write to this file outside of nix. Since home-manager manages it via `xdg.mimeApps`, remove it before every `home-manager switch`:

```sh
rm -f ~/.config/mimeapps.list ~/.config/mimeapps.list.backup
```

Do not use `-b backup` to work around conflicts — if a `.backup` file already exists from a prior run, that flag fails too. Investigate and delete conflicting files directly.

**Bazel:** use the `writeShellScriptBin "bazel"` wrapper delegating to `bazelisk`. Do not add `pkgs.bazelisk` directly.

**Go:** use `pkgs-go.go_1_24`, not `pkgs.go`. The `pkgs-go` arg is only available in modules that declare it in their parameter list.

**Rust:** use `pkgs-rust.stable.withComponents [...]` + `pkgs-rust.rust-analyzer` (from fenix). Do NOT use `pkgs.rustc`, `pkgs.cargo`, etc. — they lack `rust-src` and break rust-analyzer in GUI apps.

**New files:** must be `git add`ed before they are visible to the flake evaluator.

---

## References

- `.claude/CONTEXT.md` — current project state
- `.claude/DECISIONS.md` — architectural decisions and rationale
- `.claude/ERRORS.md` — past mistakes and systemic fixes
- `.claude/TASKS.md` — current tasks and priorities
- `README.md` — general notes and instructions for human reference
