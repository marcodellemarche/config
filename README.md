# Nix Home Manager

Configurazione dichiarativa dell'ambiente di sviluppo tramite [Home Manager](https://github.com/nix-community/home-manager).

## Setup su una nuova macchina

### 1. Installa Nix

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Riavvia il terminale (o esegui `source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh`).

### 2. Clona questa repo

```sh
git clone https://github.com/marcodellemarche/nix ~/nix
```

### 3. Applica la configurazione

```sh
nix run nixpkgs#home-manager -- switch --flake ~/nix/#$USER
```

### 4. Imposta zsh come shell di default

```sh
echo $(which zsh) | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

Riavvia il terminale.

---

## Aggiornare

```sh
# Aggiorna i flake inputs all'ultima versione disponibile
nix flake update ~/nix

# Riapplica la configurazione
home-reload
```

## Comandi utili

| Comando | Descrizione |
|---------|-------------|
| `home-reload` | Riapplica la configurazione home-manager |
| `nix flake update ~/nix` | Aggiorna tutti i pacchetti |
| `home-manager generations` | Mostra le generazioni precedenti |
| `home-manager rollback` | Torna alla generazione precedente |

## Struttura

```
nix/
├── flake.nix               # Entry point: inputs e outputs
├── flake.lock              # Lock file (versioni pinned)
└── home-manager/
    ├── home.nix            # Configurazione principale
    └── apps/
        └── tmux.nix        # Configurazione tmux
```
