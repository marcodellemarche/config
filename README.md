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

> **Note:** home-manager automatically resolves `$USER@$(nix eval --expr builtins.currentSystem --raw)` to find the matching `homeConfigurations` entry (e.g. `marcodellemarche@x86_64-linux`).

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

### Rust

Rust toolchain is managed via [fenix](https://github.com/nix-community/fenix) (a Nix flake for Rust toolchains) rather than the individual nixpkgs packages. This matters because fenix bundles `rust-src` directly into the sysroot, so `rustc --print sysroot` returns a path that contains `lib/rustlib/src/rust/library`. `rust-analyzer` discovers stdlib sources via the sysroot and works correctly in both the terminal and VSCode without any extra configuration.

Available: `rustc`, `cargo`, `clippy`, `rustfmt`, `rust-analyzer`.

### Python

Python 3.12 is available with `pip` and `matplotlib` pre-installed. Managed via `apps/dev.nix`.

### SSH

Static hosts are declared in `apps/ssh.nix` and deployed to `~/.ssh/config`. Connect with their short names:

```sh
ssh giulio-1
ssh pacco-3
```

All connections use `~/.ssh/id_ed25519` by default with keepalive settings (`ServerAliveInterval 60`).

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
