# Nix Home Manager

Declarative development environment managed by [Home Manager](https://github.com/nix-community/home-manager).

## Setup on a new machine

### 1. Install Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Restart the terminal (or run `source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`).

### 2. Clone this repo

```sh
git clone https://github.com/marcodellemarche/config.git ~/nix
```

### 3. Apply the configuration (first time)

```sh
nix run nixpkgs#home-manager -- switch --flake ~/nix
```

> **Note:** home-manager automatically resolves `$USER` to find the matching `homeConfigurations` entry.

### 4. Set zsh as the default shell

```sh
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

Restart the terminal. From here on, use `home-reload` for subsequent updates.

### 5. Restore SSH key

The SSH keypair is stored in Bitwarden. Retrieve `id_ed25519` (private) and `id_ed25519.pub` (public) and place them in `~/.ssh/`:

```sh
mkdir -p ~/.ssh
# paste/copy the key files from Bitwarden, then:
chmod 700 ~/.ssh
chmod 600 ~/.ssh/id_ed25519
chmod 644 ~/.ssh/id_ed25519.pub
```

Alternatively, generate a fresh keypair and add the public key to your accounts:

```sh
ssh-keygen -t ed25519 -C "mferretti93@gmail.com"
cat ~/.ssh/id_ed25519.pub   # add this to GitHub, coder, servers, etc.
```

### 6. Connect coder

```sh
coder login https://coder.cubbit.dev
mkdir -p ~/.ssh/config.d
coder config-ssh --ssh-config-file ~/.ssh/config.d/coder
```

### 7. Import GPG key and enable git signing

The GPG key is stored in Bitwarden. Export it from an existing machine with:

```sh
gpg --export-secret-keys --armor YOUR_KEY_ID > gpg-private.asc
```

On the new machine, import and trust it:

```sh
gpg --import gpg-private.asc
gpg --edit-key YOUR_KEY_ID   # then type "trust", select 5 (ultimate), "quit"
rm gpg-private.asc
```

Get the key ID and update `home-manager/apps/git.nix`:

```sh
gpg --list-secret-keys --keyid-format LONG
# Replace YOUR_KEY_ID in git.nix with the key ID from the sec line
# e.g. sec   ed25519/ABC123DEF456 → key ID is ABC123DEF456
home-reload
```

### 8. Set Brave as default browser

Brave is configured as the default via `xdg.mimeApps`. After applying the config, verify with:

```sh
xdg-settings get default-web-browser   # should show brave-browser.desktop
xdg-open https://example.com           # should open in Brave
```

---

## Updating

```sh
# Update all flake inputs to latest
nix flake update ~/nix

# Re-apply configuration
home-reload
```

## Useful commands

| Command | Description |
|---------|-------------|
| `home-reload` | Re-apply the home-manager configuration |
| `nix flake update ~/nix` | Update all packages to latest versions |
| `home-manager generations` | List previous generations |
| `home-manager rollback` | Revert to the previous generation |

---

## Features

### Shell

| Alias | Expands to | Notes |
|-------|-----------|-------|
| `ls` | `eza` | Modern `ls` with colour and icons |
| `ll` | `eza -l` | Long listing |
| `la` | `eza -la` | Long listing including hidden files |
| `lt` | `eza --tree` | Tree view |
| `cat` | `bat` | Syntax-highlighted file viewer |
| `z <name>` | `zoxide` | Jump to a frecently-used directory by fuzzy name |
| `home-reload` | `home-manager switch …` | Re-apply the nix config |

Also available: `fd` (fast `find`), `rg` (ripgrep — fast `grep`), `btop` (system monitor).

**fzf** is available in the shell: `Ctrl+R` for history search, `Ctrl+T` for file search, `Alt+C` to cd into a directory.

### Tmux

Key bindings (prefix is `Ctrl+B`):

| Binding | Action |
|---------|--------|
| `prefix + c` | New window (preserves current path) |
| `prefix + "` | Split horizontally (preserves current path) |
| `prefix + %` | Split vertically (preserves current path) |
| `prefix + v` | Enter copy mode, start selection |
| `y` / `Enter` (copy mode) | Copy selection to **system clipboard** via xclip |
| Mouse drag (copy mode) | Copy selection to **system clipboard** on release |

Sessions are saved automatically every 10 minutes via **tmux-continuum** and restored on next start via **tmux-resurrect**.

### Git

Useful aliases (usable as `git <alias>`):

| Alias | Command |
|-------|---------|
| `cane` | `commit --amend --no-edit` |
| `fap` | `fetch -ap` |
| `lol` | Pretty one-line graph log |
| `lola` | Same, all branches |
| `rod` | `rebase origin/develop` |
| `puf` | `push --force` |
| `pr` | `pull --rebase` |

**delta** is configured as the git pager — diffs are syntax-highlighted with side-by-side view.

### Bazel

`bazel` is a wrapper around `bazelisk` — it automatically downloads and uses the correct Bazel version declared in `.bazelversion`. No manual version management needed.

### direnv

`direnv` is active with `nix-direnv`. In any directory with an `.envrc`, the environment is loaded/unloaded automatically on `cd`. For nix-based projects, add `use flake` to `.envrc` and the flake's dev shell will activate instantly (result is cached by nix-direnv).

```sh
# Example .envrc
echo "use flake" > ~/cubbit/.envrc
direnv allow
```

### GPG

GPG and gpg-agent are managed declaratively (`apps/gpg.nix`). The agent uses pinentry-gnome3 and caches passphrases for 1 hour (max 2 hours). Git commit signing is enabled by default — just set your key ID in `apps/git.nix`.

### Default browser

Brave is set as the default browser via `xdg.mimeApps`. All `http`/`https` links opened with `xdg-open` route to Brave.

### Android Studio

Android Studio is managed via `pkgs.android-studio` (x86_64 only). The Android SDK is downloaded by the IDE wizard on first launch to `~/Android/Sdk`.

`ANDROID_HOME` and the `platform-tools`/`emulator` paths are set automatically via `home.sessionVariables` and `home.sessionPath` — no manual `.zshrc` edits needed.

`~/.nix-profile/bin` is prepended in `home.sessionPath` ahead of the Android SDK entries so that Nix-managed binaries take precedence over duplicates shipped inside `platform-tools` (e.g. `sqlite3`).

**System-level prerequisites** (one-time, requires sudo — not manageable by home-manager):

```sh
# Allow unprivileged user namespaces (required by the FHS sandbox)
sudo sysctl -w kernel.unprivileged_userns_clone=1
echo 'kernel.unprivileged_userns_clone=1' | sudo tee /etc/sysctl.d/99-unprivileged-userns.conf

# Allow AppArmor to use them
sudo sysctl -w kernel.apparmor_restrict_unprivileged_userns=0
echo 'kernel.apparmor_restrict_unprivileged_userns=0' | sudo tee /etc/sysctl.d/99-apparmor-userns.conf
```

After first launch, run the "Standard installation" wizard — it downloads the SDK, Build-Tools, and Platform-Tools automatically.

---

### Rust

Rust toolchain is managed via [fenix](https://github.com/nix-community/fenix) (a Nix flake for Rust toolchains) rather than the individual nixpkgs packages. This matters because fenix bundles `rust-src` directly into the sysroot, so `rustc --print sysroot` returns a path that contains `lib/rustlib/src/rust/library`. `rust-analyzer` discovers stdlib sources via the sysroot and works correctly in both the terminal and VSCode without any extra configuration.

Available: `rustc`, `cargo`, `clippy`, `rustfmt`, `rust-analyzer`.

### Python

Python 3.12 is available with `pip` and `matplotlib` pre-installed. Managed via `apps/dev.nix`.

### OCR

**ocrmypdf** adds a searchable text layer to PDF files using Tesseract OCR. Managed via `pkgs.ocrmypdf` in `apps/dev.nix`.

```sh
# Add OCR layer to a scanned PDF
ocrmypdf input.pdf output.pdf

# Force re-OCR even if text is already present
ocrmypdf --force-ocr input.pdf output.pdf

# Specify language(s)
ocrmypdf -l ita+eng input.pdf output.pdf
```

Supported languages are those enabled in the Tesseract override: `eng`, `ita`, `por`.

### cloudflared

`cloudflared` is the Cloudflare Tunnel client. Useful for exposing local services through a Cloudflare Tunnel or reaching resources protected by Cloudflare Access.

```sh
# Authenticate against your Cloudflare account
cloudflared tunnel login

# Reach a host behind Cloudflare Access via SSH
cloudflared access ssh --hostname ssh.example.com
```

Managed via `pkgs.cloudflared` in `apps/dev.nix`.

### Supabase CLI

`supabase` is the Supabase CLI, used to manage local development stacks, run migrations, and interact with Supabase projects.

```sh
# Log in to your Supabase account
supabase login

# Start a local Supabase stack (requires Docker)
supabase start

# Link a local project to a remote one
supabase link --project-ref <ref>
```

Managed via `pkgs.supabase-cli` in `apps/dev.nix`.

### Codex CLI

`codex` is OpenAI's terminal coding agent, alongside `claude-code` and `antigravity-cli`.

```sh
# Start an interactive session
codex

# Log in
codex login
```

Managed via `pkgs.codex` in `apps/dev.nix`.

### Antigravity CLI

Google retired Gemini CLI (June 2026) in favor of Antigravity CLI — same role (terminal coding agent, alongside `claude-code` and `codex`), new Go-based implementation. The binary is `agy`, not `antigravity` (that name is aliased to `antigravity-ide`, the separate VS Code-fork IDE — not installed here).

```sh
# Start an interactive session (prompts for Google OAuth login on first run)
agy
```

Managed via `pkgs.antigravity-cli` in `apps/dev.nix`.

### Pi coding agent

`pi` ([pi.dev](https://pi.dev/)) is a minimal terminal coding agent, alongside `claude-code`, `codex` and `agy`. Unlike the others it is provider-agnostic by design: any OpenAI-, Anthropic- or Google-compatible endpoint can be added as a custom provider.

```sh
# Start an interactive session in the current directory
pi

# One-shot, non-interactive
pi -p "spiega questo repo"

# Pick / save a model:  /model  (or Ctrl+L) inside the TUI, Ctrl+S to save as default
# Log in to a subscription provider (Claude Pro/Max, ChatGPT, Copilot):  /login
```

Config lives in `~/.pi/agent/` (`auth.json`, `models.json`, `settings.json`, `AGENTS.md`, sessions). It also reads the project's `AGENTS.md` / `CLAUDE.md`.

**Custom LLM providers** go in `~/.pi/agent/models.json`, reloaded every time `/model` is opened (no restart). Structure: `providers` → free-form name → `baseUrl` + `api` (`openai-completions` / `openai-responses` / `anthropic-messages` / `google-generative-ai`) + `apiKey` + `models[]`. Only `models[].id` is mandatory; `name`, `reasoning`, `input`, `contextWindow`, `maxTokens`, `cost`, `samplingParams` are optional. `apiKey` accepts `"$VAR"` (env var), `"!cmd"` (stdout of a shell command) or a literal string. A model stays hidden in `/model` until it has credentials — from `apiKey`, from `/login`, or from `--api-key`.

Cubbit's **Mimir** (the same gateway `opencode` uses in `~/cubbit/opencode.jsonc` — Bifrost in front of vLLM) exposes two models. Capabilities below were probed directly against `https://mimir.cubbit.dev/v1`, not assumed:

| | `vllm/mimir` | `cubbit/mimir-small` |
|---|---|---|
| base model (self-reported) | GLM (Z.ai) | Qwen (Alibaba) |
| server `max_model_len` (= `max_total_tokens`) | **1 048 576** | **262 144** |
| context set in the opencode config | 360 448 | 120 832 |
| images | **yes** | **yes** |
| tool calling | yes (`finish_reason: tool_calls`) | yes |
| structured output (`json_schema`) | yes | yes |
| reasoning | always on, returned in `reasoning` + `reasoning_details` | always on, cannot be turned off |
| `reasoning_effort` values | any string accepted (unvalidated) | strict: `low`, `medium`, `xhigh` (default) — `high` and `max` return HTTP 400 |
| `chat_template_kwargs.thinking.type: "disabled"` | shortens reasoning, does not remove it | no measurable effect |
| `developer` role | accepted | accepted |

Two things the opencode config does not tell you and that matter here: **`vllm/mimir` accepts images too** (opencode only declares `attachment` on `mimir-small`), and **`mimir-small` rejects `reasoning_effort: high`/`max`** — which is exactly what pi would send for its `high`/`max` thinking levels, so those need remapping.

Resulting `~/.pi/agent/models.json`:

```json
{
  "providers": {
    "cubbit": {
      "baseUrl": "https://mimir.cubbit.dev/v1",
      "api": "openai-completions",
      "apiKey": "!cat /home/marcodellemarche/cubbit/mimir-key",
      "headers": { "x-bf-passthrough-extra-params": "true" },
      "compat": { "supportsDeveloperRole": false },
      "models": [
        {
          "id": "vllm/mimir", "name": "Mimir", "reasoning": true,
          "input": ["text", "image"], "contextWindow": 1048576, "maxTokens": 32768,
          "thinkingLevelMap": { "xhigh": "xhigh", "max": "max" },
          "samplingParams": {
            "chat_template_kwargs": { "thinking": { "type": "enabled" } }
          }
        },
        {
          "id": "cubbit/mimir-small", "name": "Mimir Small", "reasoning": true,
          "input": ["text", "image"], "contextWindow": 262144, "maxTokens": 32768,
          "thinkingLevelMap": {
            "minimal": "low", "low": "low", "medium": "medium",
            "high": "xhigh", "xhigh": "xhigh", "max": null
          }
        }
      ]
    }
  }
}
```

Notes on the mapping:

- **`apiKey`** — pi has no `{file:...}` like opencode, but `"!cmd"` runs a shell command and uses its stdout, so the key is read at runtime from `~/cubbit/mimir-key` (gitignored in the cubbit repo) and never stored in this repo. `models.json` itself is `chmod 600` and lives outside nix — home-manager does not manage it.
- **`thinkingLevelMap`** — tristate: omitted level → provider default (and `xhigh`/`max` are unavailable unless mapped explicitly), a string → that exact value is sent, `null` → the level is hidden/clamped. It is what keeps pi's `--thinking high` from producing a 400 on `mimir-small`.
- **`samplingParams`** — pi's passthrough for arbitrary extra request params; it carries `chat_template_kwargs`, paired with the `x-bf-passthrough-extra-params` header the gateway requires.
- **`supportsDeveloperRole: false`** — kept only to mirror what opencode's `@ai-sdk/openai-compatible` does (system prompt as a `system` message). Both models were verified to accept the `developer` role as well, so this flag can be dropped if you ever want to.
- **`contextWindow`** — set to the server's real `max_model_len` (1M and 256K), not to the more conservative 360 448 / 120 832 the opencode config uses. Note that vLLM's limit is `max_total_tokens`, i.e. **input + output**: the effective input budget is the number above minus `maxTokens`. Going over returns a plain HTTP 400 from vLLM naming the exact limit, so an overshoot fails loudly rather than silently truncating.

```sh
pi --list-models                                     # both models, thinking=yes, images=yes
pi --model cubbit/vllm/mimir                         # GLM, thinking, images
pi --model cubbit/cubbit/mimir-small --thinking low  # Qwen, smaller and faster
pi --model cubbit/vllm/mimir @screenshot.png "cosa non va in questa UI?"
```

Inside the TUI: `/model` (or Ctrl+L) to switch, Ctrl+S on the highlighted model to save it as the startup default.

Managed via `pkgs.pi-coding-agent` in `apps/dev.nix` (binary is `pi`).

### OpenDesign

OpenDesign ([open-design.ai](https://open-design.ai/), [nexu-io/open-design](https://github.com/nexu-io/open-design)) is a local-first design layer that drives an existing coding-agent CLI: you pick a design system and a template, it composes the prompt and streams the agent's file writes into a live preview. It ships 152 design systems as `DESIGN.md` packages.

It is **not** managed by nix and **not** in nixpkgs. There is no prebuilt Linux desktop artifact either (upstream issue #4368), so on Ubuntu it runs from source at `~/open-design`:

```sh
git clone https://github.com/nexu-io/open-design.git ~/open-design
nix shell nixpkgs#nodejs_24 nixpkgs#pnpm_10 --command bash -c 'cd ~/open-design && pnpm install'
```

Node `~24` and pnpm `>=10.33.2 <11` are required — both come from the ephemeral `nix shell` above, so nothing is added to the profile. `corepack enable` from the upstream instructions is **not** usable here: it writes shims into the Node prefix, which is a read-only nix store path. `pnpm_10` from nixpkgs (10.34.5) satisfies the engine range, and pnpm then self-manages down to the pinned 10.33.2.

Build the web bundle once (`next build` → static export in `apps/web/out`, ~118 MB), so the daemon can serve the UI itself on a single fixed port:

```sh
nix shell nixpkgs#nodejs_24 nixpkgs#pnpm_10 --command bash -c 'cd ~/open-design && pnpm --filter @open-design/web build'
```

After that, **`od` is the command to use** — see below. The underlying dev-mode alternative, useful when hacking on OpenDesign itself, is `pnpm tools-dev run web` (Vite/Next dev server, dynamic ports unless `--daemon-port` / `--web-port` are passed); `pnpm tools-dev` also takes `start` / `stop` / `restart` / `status` / `logs` / `check`.

**Why from source and not Docker:** the daemon spawns the agent CLI it finds on `PATH`. In a container it cannot see the host's `pi`, so the Docker path only works with a BYOK runtime — not with the local pi + Mimir setup.

The daemon scans `PATH` and auto-detects the installed agents; on this machine it finds `claude`, `codex`, `opencode`, `pi` and `agy`. The pi adapter (`docs/agent-adapters.md` §5.10) drives `pi --mode rpc` over JSON-RPC and builds its model picker by parsing `pi --list-models`, so **the Cubbit Mimir provider configured for pi shows up in OpenDesign automatically** as `cubbit/vllm/mimir` and `cubbit/cubbit/mimir-small`. Thinking levels (`off` … `xhigh`) and image input are wired through too.

Known rough edges on this setup:

- pi logs `EISDIR` warnings for `--append-system-prompt <dir>` on the `skills/` and `design-systems/` directories. Those are path *hints* — the actual skill and design-system content travels in the composed prompt — so the run is unaffected.
- A bare `POST /api/chat` with no project ends with `artifactCount: 0` and the agent writes into the repo's cwd. Drive it from the web UI (which creates a project workspace) rather than by hand.
- `pnpm install` leaves four build scripts unapproved: `node-pty` (terminal shell), `@ffmpeg-installer/linux-x64` and `@ffprobe-installer/linux-x64` (video artifacts), `@google/genai`. Run `pnpm approve-builds` if those features are needed.
- The checkout plus `node_modules` is ~3.2 GB.

#### `od` — the command to use

`od` is a zsh alias in `apps/zsh.nix` pointing at the checkout's CLI entrypoint:

```nix
od = "nix run nixpkgs#nodejs_24 -- ~/open-design/apps/daemon/bin/od.mjs";
```

`nix run` with a warm store adds ~80 ms, so nothing is installed into the profile and no `nix shell` is needed at call time. Bare `od` starts the daemon on port 7456 and opens the web UI; the rest is the upstream CLI:

```sh
od                      # start daemon + web UI on http://127.0.0.1:7456
od config list          # read the app config
od config set <k> <v>   # write it (use --value-json for structured values)
od export / lint / mcp / plugin / automation / memory / research …
```

**The agent and model are pinned in the app config**, not in this repo — `~/open-design/.od/app-config.json` is runtime state outside nix:

```sh
od config set agentId pi
od config set agentModels --value-json '{"pi":{"model":"cubbit/vllm/mimir","reasoning":"medium"}}'
```

Careful with `config set`: a positional value is treated as a string, so a structured value is **silently dropped** — it prints `[config] set agentModels` and writes nothing. `--value-json` is required for anything that is not a scalar.

`od config set designSystemId <id>` exists too but does less than it looks: the app-level default is gated on `allowAppDefault: project === null`, so it only applies to runs with no project. For folder projects the project's own `designSystemId` is what counts.

#### Starting a project on an existing folder


Two independent pieces: *which folder the agent writes into*, and *which design system it follows*.

**1. Point a project at an existing folder.** OpenDesign projects normally live under the daemon data dir; a project can be bound to an external folder instead — the "imported folder" case, which stores the path as `metadata.baseDir`. `POST /api/import/folder` does the whole thing in one call, project creation plus design system:

```sh
D=http://127.0.0.1:7456

curl -s -X POST $D/api/import/folder -H 'content-type: application/json' \
  -d '{"baseDir":"'"$HOME"'/cubbit","name":"cubbit","designSystemId":"user:cubbit"}'
```

The project id is generated, so calling it twice on the same folder creates a duplicate; check `GET /api/projects` for an existing `metadata.baseDir` match first. In the UI this is the import-folder flow, and the design system is then picked in the composer. Guardrails: `$HOME` itself, system directories, and `~/.ssh` / `~/.aws` / `~/.gnupg` / `~/.kube` / `~/.docker` are refused as project roots.

The older two-step form (`POST /api/projects` with an explicit `id`, then `POST /api/projects/:id/working-dir` with `baseDir`) also works; `POST /api/projects` rejects a `name`-only body with `invalid project id`.

**2. Install a design system.** The daemon data dir is `~/open-design/.od/` (`<projectRoot>/.od`, overridable with `OD_DATA_DIR`); user-installed design systems live in `~/open-design/.od/design-systems/<slug>/`:

```text
~/open-design/.od/design-systems/cubbit/
├── DESIGN.md       # canonical design prose, with the frontmatter block
├── tokens.css      # compiled CSS custom properties
├── manifest.json   # schemaVersion od-design-system-project/v1, id, name, category, source, files
└── metadata.json   # title, category, surface, status, timestamps
```

**The `metadata.json` `status` field is the trap.** A user design system defaults to `status: "draft"`, and the run-time gate is literally `summary?.status !== 'draft'` — a draft is skipped **silently** and the run falls back to the app default design system. There is no error, no warning in the stream: the artifact simply comes out in the wrong brand. Set `"status": "published"`.

The Cubbit brand kit in `~/Downloads/Cubbit/` was already in OpenDesign's format (a `DESIGN.md` with the `name`/`category`/`surface`/`colors` frontmatter, plus a full token set), so it installs as-is. What maps to what:

| installed file | source | read by |
|---|---|---|
| `DESIGN.md` | `DESIGN.md` | prompt (canonical prose) |
| `tokens.css` | `system/variables.css` | prompt (token block) |
| `USAGE.md` | `SKILLS.md` | prompt |
| `components.html` | `system/kit.html` | prompt (component fixture, 77 KB) |
| `design-tokens.json` | `system/tokens.default.json` | tooling |

`system/variables.css` already carries both the `:root` light block and a `.dark` block — `system/variables.dark.css` is a separate dark-first variant and must **not** be concatenated onto it, since both declare `:root`.

On first listing the daemon fleshes out the package on its own (`preview/` review cards, `colors_and_type.css`, a generated `SKILL.md`, a placeholder `assets/logo.svg`, `context/provenance.*`), tracked in `.od-generated.json`. Those are generated from the DESIGN.md frontmatter; the real tokens still come from `tokens.css`.

Left undeclared on purpose: `componentsManifest` (a derived cache regenerated from `components.html` + `tokens.css` by upstream tooling) and `importMode` (`hybrid`/`verbatim` carry source-evidence requirements this package does not satisfy).

It registers as **`user:cubbit`** and shows up in `/api/design-systems` alongside the 152 bundled ones. Selecting it per run:

```sh
curl -sN -X POST $D/api/chat -H 'content-type: application/json' \
  -d '{"agentId":"pi","model":"cubbit/vllm/mimir","reasoning":"low",
       "projectId":"cubbit","designSystemId":"user:cubbit",
       "message":"Crea index.html: landing minimale con un bottone primario."}'
```

Verified: with `status: draft` the output came back in the bundled "Neutral Modern" palette (`--accent: #2f6feb`, Inter); with `status: published` the same prompt produced `#1677ff`, `--brand-color-primary`, Titillium Web and Source Sans 3 — the actual Cubbit tokens.

The daemon also auto-creates a backing project named `ds-cubbit` (`importedFrom: design-system`) so the system can be edited from the UI. That is expected; leave it alone.

### WireGuard

`wireguard-tools` provides `wg` and `wg-quick` userspace utilities. The kernel module ships with mainline Linux on Ubuntu, so no extra setup is required.

```sh
# Bring up a tunnel from a config file at /etc/wireguard/wg0.conf
sudo wg-quick up wg0
sudo wg-quick down wg0

# Show interface status
sudo wg show
```

Configuration files live in `/etc/wireguard/` and must be owned by root (`chmod 600`). They are not managed by home-manager.

### Tailscale

Tailscale is **not** managed by nix. The `tailscaled` daemon needs to run as root via systemd, which standalone home-manager cannot provide. Installed via the official APT repo:

```sh
curl -fsSL https://tailscale.com/install.sh | sh
```

The installer adds `pkgs.tailscale.com` to APT sources, installs the `tailscale` package, and enables `tailscaled.service`.

```sh
# Authenticate and join the tailnet (opens a browser)
sudo tailscale up

# Status / IP / peers
tailscale status
tailscale ip

# Disconnect (daemon keeps running)
sudo tailscale down
```

Updates ride along with regular `apt upgrade`.

### Brave

Brave is **not** managed by nix. The Nix-built Chromium on non-NixOS Linux cannot initialize GLX/EGL against the system's GPU drivers (Mesa for Intel, proprietary for NVIDIA), which disables WebGL and all hardware acceleration. The APT package uses the system's libGL and gets full hardware acceleration automatically.

Install from Brave's official APT repo:

```sh
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
  https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] \
  https://brave-browser-apt-release.s3.brave.com/ stable main" \
  | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser
```

The binary is `brave-browser` (also aliased as `brave` in zsh). Updates ride along with `apt upgrade`. The default-browser registration via `xdg.mimeApps` in `home.nix` still works because the APT package ships `brave-browser.desktop` at `/usr/share/applications/`.

### NVIDIA driver

The NVIDIA proprietary driver is **not** managed by nix. Kernel modules, DKMS hooks, and PRIME profile setup must be wired into the system at boot — standalone home-manager cannot do this. Required for WebGL / GPU-accelerated browsers (Chromium-based browsers blacklist `nouveau`).

Install the recommended driver via APT:

```sh
ubuntu-drivers devices              # list available drivers
sudo ubuntu-drivers install nvidia:595
sudo reboot
```

Verify after reboot:

```sh
nvidia-smi                          # should list the GPU
prime-select query                  # on-demand: Intel primary, NVIDIA on-demand
```

`nvidia-prime` is pulled in automatically and sets the on-demand PRIME profile, which is the right choice on hybrid Intel + NVIDIA laptops: Intel drives the desktop, NVIDIA wakes up only for GPU-intensive apps. Browsers detect the NVIDIA GPU and enable hardware-accelerated WebGL. Updates ride along with `apt upgrade`.

### OpenHuman

OpenHuman is **not** managed by nix. It's a Tauri desktop app (Rust core + Node/pnpm frontend) with no upstream `flake.nix`/`default.nix` — packaging it from source would mean vendoring both a Cargo build and a pnpm/Tauri build (webkit2gtk, etc.), which is disproportionate for this app. Installed from the official `.deb` release:

```sh
curl -sL https://api.github.com/repos/tinyhumansai/OpenHuman/releases/latest \
  | grep browser_download_url | grep amd64.deb
# download the URL above, then:
sudo apt-get install -y --no-install-recommends ./OpenHuman_*_amd64.deb
```

The binary is `/usr/bin/OpenHuman`, with a desktop entry at `/usr/share/applications/OpenHuman.desktop`. Installed as apt package `open-human` (pulls in `libxdo3`). Updates: re-download the latest `.deb` and re-run the install command (no APT repo, so it does not ride along with `apt upgrade`).

---

### SSH

Static hosts are declared in `apps/ssh.nix` and deployed to `~/.ssh/config`. Connect with their short names:

```sh
ssh giulio-1
ssh pacco-3
```

All connections use `~/.ssh/id_ed25519` by default with keepalive settings (`ServerAliveInterval 60`).

Coder workspaces are reached as `ssh coder.<workspace>` (e.g. `ssh coder.mdm`). Their config block is **not** in `apps/ssh.nix` — it is generated by Coder into `~/.ssh/config.d/coder` (pulled in via the `Include ~/.ssh/config.d/*` line). Regenerate it after creating/updating workspaces — always with the `--ssh-config-file` flag, otherwise Coder appends the block to `~/.ssh/config` directly and it ends up duplicated:

```sh
coder config-ssh --ssh-config-file ~/.ssh/config.d/coder
```

**VS Code Remote-SSH:** `~/.ssh/config` is a read-only symlink into the Nix store, so Remote-SSH fails with `EACCES` when it opens the file read-write. Workaround: a writable `~/.ssh/config.vscode` that just does `Include /home/marcodellemarche/.ssh/config` (which transitively pulls in `config.d/*`), and the setting `"remote.SSH.configFile": "/home/marcodellemarche/.ssh/config.vscode"` in `~/.config/Code/User/settings.json`. This file lives outside Nix on purpose — it must stay writable for the extension. Reload the VS Code window after changing the setting.

---

## Structure

```
nix/
├── flake.nix               # Entry point: inputs and outputs
├── flake.lock              # Lock file (pinned versions)
└── home-manager/
    ├── home.nix            # Identity, fonts, cursor, desktop entries
    ├── config/
    │   └── p10k.zsh        # Powerlevel10k prompt config
    └── apps/
        ├── zsh.nix         # Zsh, p10k, fzf, eza, zoxide, aliases
        ├── git.nix         # Git settings, LFS, aliases
        ├── dev.nix         # Dev packages, bazel wrapper, direnv
        ├── tmux.nix        # Tmux with resurrect/continuum, xclip
        ├── ssh.nix         # SSH static hosts; coder via ~/.ssh/config.d/coder
        └── gpg.nix         # GPG keyring, gpg-agent with pinentry-gnome3
```
