# Project Context

> Updated by Claude at the end of every productive session.
> Last updated: 2026-04-26

---

## Current state

The configuration is healthy and applied. Removed `builtins.currentSystem` / `--impure` from `flake.nix` by introducing a `mkConfig` helper that takes `system` and `username`. Two `homeConfigurations` are defined keyed by username: `marcodellemarche` (x86_64-linux) and `ubuntu` (aarch64-linux). The `username` is passed via `extraSpecialArgs` and used in `home.nix` instead of hardcoded values.

---

## Next steps (in order)

No active tasks. Waiting for user direction.

---

---

## Recent decisions

- [2026-04-26] Registered `obsidian://` URI handler: added `x-scheme-handler/obsidian` to mimeType in `obsidian` desktop entry, added `%U` to exec, declared handler in `xdg.mimeApps.defaultApplications`
- [2026-04-26] Added `pkgs.ocrmypdf` to `apps/dev.nix` — adds searchable text layer to PDF via Tesseract
- [2026-03-27] Added Android Studio dev environment: `pkgs.android-studio`, `pkgs.jdk17`, `pkgs.glib` (for gsettings in FHS sandbox), `ANDROID_HOME` sessionVariable, Android SDK paths in sessionPath
- [2026-03-14] Removed `--impure` by replacing `builtins.currentSystem` with explicit `mkConfig system username` entries in `flake.nix`
- [2026-03-07] Replaced wealthfolio with ghostfolio — ghostfolio is self-hosted/web-based, no desktop entry needed
- [2026-03-07] Adopted claude-template structure — added `.claude/{CONTEXT,DECISIONS,ERRORS,TASKS}.md`

---

## Active warnings

- The nix store path for home-manager (`/nix/store/60xvqicq.../bin/home-manager`) may become stale after a `nix flake update`. If it fails, fall back to `nix run nixpkgs#home-manager`.
