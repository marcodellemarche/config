# Project Context

> Updated by Claude at the end of every productive session.
> Last updated: 2026-03-07

---

## Current state

The configuration is healthy and applied. All packages build and activate correctly. The most recent change replaced wealthfolio with ghostfolio (`pkgs.ghostfolio` in `home.nix`). The template structure (CLAUDE.md + `.claude/`) has just been adopted from `~/claude-template`.

---

## Next steps (in order)

No active tasks. Waiting for user direction.

---

## Recent decisions

- [2026-03-07] Replaced wealthfolio with ghostfolio — ghostfolio is self-hosted/web-based, no desktop entry needed
- [2026-03-07] Adopted claude-template structure — added `.claude/{CONTEXT,DECISIONS,ERRORS,TASKS}.md`

---

## Active warnings

- `~/.config/mimeapps.list` will conflict on every `home-manager switch` unless deleted first — GNOME writes to it outside of nix. See Known anti-patterns in `CLAUDE.md`.
- The nix store path for home-manager (`/nix/store/60xvqicq.../bin/home-manager`) may become stale after a `nix flake update`. If it fails, fall back to `nix run nixpkgs#home-manager`.
