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
