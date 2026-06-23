# Project Context

> Updated by Claude at the end of every productive session.
> Last updated: 2026-05-21

---

## Current state

The configuration is healthy and applied. Removed `builtins.currentSystem` / `--impure` from `flake.nix` by introducing a `mkConfig` helper that takes `system` and `username`. Two `homeConfigurations` are defined keyed by username: `marcodellemarche` (x86_64-linux) and `ubuntu` (aarch64-linux). The `username` is passed via `extraSpecialArgs` and used in `home.nix` instead of hardcoded values.

---

## Next steps (in order)

No active tasks. Waiting for user direction.

---

---

## Recent decisions

- [2026-05-21] Migrated Brave from nix to APT — out-of-nix intentional install. Nix-built Chromium on Ubuntu cannot initialize GLX/EGL (`glXQueryExtensionsString returned NULL`), disabling WebGL and all GPU acceleration. APT package uses system libGL and gets hardware acceleration automatically. Removed `pkgs.brave`, `brave-browser` desktop entry, and `--no-sandbox` alias from nix; `xdg.mimeApps` default still works because APT ships `brave-browser.desktop`. Documented in README under "Brave".
- [2026-05-21] Installed `nvidia-driver-595` (proprietary) + `nvidia-prime` via APT — out-of-nix intentional install. Replaces `nouveau`. PRIME profile set to `on-demand` (Intel primary, NVIDIA wakes for GPU-intensive apps). Documented in README under "NVIDIA driver". *Note: this alone was not enough to fix WebGL in nix-built Brave — see entry above.*
- [2026-05-20] Prepended `~/.nix-profile/bin` in `home.sessionPath` so Nix binaries (e.g. `sqlite3` 3.51.2) take precedence over duplicates shipped by Android SDK `platform-tools` (`sqlite3` 3.50.6). `pkgs.sqlite` was already installed in `apps/dev.nix`.
- [2026-05-20] Installed Tailscale via APT (official `tailscale.com/install.sh`) — out-of-nix intentional install. Standalone home-manager cannot manage the system-level `tailscaled` systemd service, so the daemon + CLI are kept in apt. Documented in README under "Tailscale".
- [2026-05-19] Added `pkgs.cloudflared` to `apps/dev.nix` — Cloudflare Tunnel client / Cloudflare Access proxy
- [2026-05-18] Added `pkgs.wireguard-tools` to `apps/dev.nix` — userspace `wg`/`wg-quick`; kernel module già in mainline Linux su Ubuntu
- [2026-04-26] Registered `obsidian://` URI handler: added `x-scheme-handler/obsidian` to mimeType in `obsidian` desktop entry, added `%U` to exec, declared handler in `xdg.mimeApps.defaultApplications`
- [2026-04-26] Added `pkgs.ocrmypdf` to `apps/dev.nix` — adds searchable text layer to PDF via Tesseract
- [2026-03-27] Added Android Studio dev environment: `pkgs.android-studio`, `pkgs.jdk17`, `pkgs.glib` (for gsettings in FHS sandbox), `ANDROID_HOME` sessionVariable, Android SDK paths in sessionPath
- [2026-03-14] Removed `--impure` by replacing `builtins.currentSystem` with explicit `mkConfig system username` entries in `flake.nix`
- [2026-03-07] Replaced wealthfolio with ghostfolio — ghostfolio is self-hosted/web-based, no desktop entry needed
- [2026-03-07] Adopted claude-template structure — added `.claude/{CONTEXT,DECISIONS,ERRORS,TASKS}.md`

---

## Active warnings

- The nix store path for home-manager (`/nix/store/60xvqicq.../bin/home-manager`) may become stale after a `nix flake update`. If it fails, fall back to `nix run nixpkgs#home-manager`.
- Use `nix flake update --flake ~/nix` to update flake inputs (correct form; old positional `nix flake update ~/nix` is outdated).
