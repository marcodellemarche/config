# Project Context

> Updated by Claude at the end of every productive session.
> Last updated: 2026-03-14

---

## Current state

The configuration is healthy and applied. Removed `builtins.currentSystem` / `--impure` from `flake.nix` by introducing a `mkConfig` helper that takes `system` and `username`. Two `homeConfigurations` are defined keyed by username: `marcodellemarche` (x86_64-linux) and `ubuntu` (aarch64-linux). The `username` is passed via `extraSpecialArgs` and used in `home.nix` instead of hardcoded values.

---

## Next steps (in order)

No active tasks. Waiting for user direction.

---

## Recent decisions

- [2026-03-14] Removed `--impure` by replacing `builtins.currentSystem` with explicit `mkConfig system username` entries in `flake.nix`
- [2026-03-07] Replaced wealthfolio with ghostfolio — ghostfolio is self-hosted/web-based, no desktop entry needed
- [2026-03-07] Adopted claude-template structure — added `.claude/{CONTEXT,DECISIONS,ERRORS,TASKS}.md`

---

## Active warnings

- `~/.config/mimeapps.list` will conflict on every `home-manager switch` unless deleted first — GNOME writes to it outside of nix. See Known anti-patterns in `CLAUDE.md`.
- The nix store path for home-manager (`/nix/store/60xvqicq.../bin/home-manager`) may become stale after a `nix flake update`. If it fails, fall back to `nix run nixpkgs#home-manager`.
