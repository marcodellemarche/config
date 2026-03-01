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
git clone https://github.com/marcodellemarche/nix ~/nix
```

### 3. Apply the configuration (first time)

```sh
nix run nixpkgs#home-manager -- switch --flake ~/nix/#$USER
```

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
        ├── dev.nix         # Dev packages, bazel wrapper
        ├── tmux.nix        # Tmux with resurrect/continuum
        └── ssh.nix         # SSH static hosts; coder via ~/.ssh/config.d/coder
```
