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

### 5. Configure the shell prompt (once)

```sh
p10k configure
```

This generates `~/.p10k.zsh`, which is sourced automatically on every shell start.

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
    ├── home.nix            # Main configuration
    └── apps/
        └── tmux.nix        # Tmux configuration
```
