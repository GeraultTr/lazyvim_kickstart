# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## First install Lazyvim and its prerequiriste (Ubuntu and WSL only for now)

```
#!/usr/bin/env bash
set -euo pipefail

# x86_64 by default. For ARM Ubuntu, run with: ARCH=arm64 bash install-lazyvim.sh
ARCH="${ARCH:-x86_64}"

PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"
OPT_DIR="$PREFIX/opt"
NVIM_APP_DIR="$OPT_DIR/nvim-linux-${ARCH}"

CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/nvim"
CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/nvim"

BACKUP_ROOT="${BACKUP_ROOT:-$HOME/.cache/lazyvim-bootstrap-backups}"
KEEP_EXISTING_CONFIG="${KEEP_EXISTING_CONFIG:-0}"   # 1 = do not replace ~/.config/nvim
SYNC_PLUGINS="${SYNC_PLUGINS:-1}"                   # 0 = skip headless :Lazy sync
INSTALL_TREESITTER_CLI="${INSTALL_TREESITTER_CLI:-0}" # 1 = install npm + tree-sitter-cli
WITH_LAZYGIT="${WITH_LAZYGIT:-0}"                   # 1 = try apt install lazygit

timestamp="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BIN_DIR" "$OPT_DIR" "$BACKUP_ROOT"

ensure_in_path() {
  case ":$PATH:" in
    *":$BIN_DIR:"*) ;;
    *)
      export PATH="$BIN_DIR:$PATH"
      if [ -f "$HOME/.bashrc" ] && ! grep -Fqs 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc"; then
        printf '\nexport PATH="$HOME/.local/bin:$PATH"\n' >> "$HOME/.bashrc"
      fi
      ;;
  esac
}

backup_path() {
  local path="$1"
  if [ -e "$path" ] || [ -L "$path" ]; then
    mkdir -p "$BACKUP_ROOT/$timestamp"
    mv "$path" "$BACKUP_ROOT/$timestamp/"
  fi
}

echo "==> Installing Ubuntu dependencies"
sudo apt-get update
sudo apt-get install -y \
  git curl ripgrep fd-find build-essential xclip ca-certificates

if [ "$INSTALL_TREESITTER_CLI" = "1" ]; then
  sudo apt-get install -y npm
  sudo npm install -g tree-sitter-cli
fi

if [ "$WITH_LAZYGIT" = "1" ]; then
  sudo apt-get install -y lazygit || true
fi

ensure_in_path

echo "==> Making fd available as 'fd' on Ubuntu"
if command -v fdfind >/dev/null 2>&1 && [ ! -e "$BIN_DIR/fd" ]; then
  ln -s "$(command -v fdfind)" "$BIN_DIR/fd"
fi

tmpdir="$(mktemp -d)"
trap 'rm -rf "$tmpdir"' EXIT

echo "==> Downloading latest Neovim"
curl -fsSL -o "$tmpdir/nvim.tar.gz" \
  "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${ARCH}.tar.gz"

echo "==> Installing Neovim into $NVIM_APP_DIR"
rm -rf "$NVIM_APP_DIR"
tar -xzf "$tmpdir/nvim.tar.gz" -C "$OPT_DIR"
ln -sfn "$NVIM_APP_DIR/bin/nvim" "$BIN_DIR/nvim"

echo "==> Installing or refreshing LazyVim starter"
if [ "$KEEP_EXISTING_CONFIG" != "1" ]; then
  if [ -d "$CONFIG_DIR/.git" ] && git -C "$CONFIG_DIR" remote get-url origin 2>/dev/null | grep -q 'LazyVim/starter'; then
    git -C "$CONFIG_DIR" fetch --depth=1 origin
    git -C "$CONFIG_DIR" checkout -f main
    git -C "$CONFIG_DIR" reset --hard origin/main
  else
    backup_path "$CONFIG_DIR"
    backup_path "$DATA_DIR"
    backup_path "$STATE_DIR"
    backup_path "$CACHE_DIR"
    git clone --depth=1 https://github.com/LazyVim/starter "$CONFIG_DIR"
  fi
fi

echo "==> Verifying nvim"
"$BIN_DIR/nvim" --version | head -n 1

if [ "$SYNC_PLUGINS" = "1" ]; then
  echo "==> Headless plugin sync"
  "$BIN_DIR/nvim" --headless "+Lazy! sync" +qa
fi

cat <<EOF

Done.

nvim binary:
  $BIN_DIR/nvim

config:
  $CONFIG_DIR

backups:
  $BACKUP_ROOT/$timestamp

Next:
  nvim
  :LazyHealth
EOF
```

## Then apply .config Editions

```
rm -rf ~/.config/nvim
git clone git@github.com:GeraultTr/lazyvim_kickstart.git ~/.config/nvim
```

Which adds the content of ~/.config/nvim/plugin/diagnostics.lua , theme.lua and outline.lua , compared to the vanilla lazyvim config

## Proper terminal font (e.g. JetBrainsMono is great for dev)
```
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts

curl -fLo "JetBrainsMono.zip" \
  https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip

unzip JetBrainsMono.zip -d JetBrainsMono
fc-cache -fv
```

## Final manual steps

### Mason install (access with :Mason , accept with x)
- python-lsp-server -> LSP for python projects

### Lazy Extras (from main menu, install with i, remove with X)
- util.project -> ensures .git repos are recognized as projects

### Setup terminal to use and aliases for quick launch

Add an alias to ~/.bashrc and reload with "source ~/.bashrc". Example:
```
alias mecha='cd ~/Documents/package/MECHA-dev && mamba activate mecha && gnome-terminal --working-directory="$PWD" -- mamba run -n "$CONDA_DEFAULT_ENV" nvim'
```
and type space qs when arriving to restore the session associated with the working directory pointed by the alias

(or at least do _mamba activate_ before triggering nvim)

