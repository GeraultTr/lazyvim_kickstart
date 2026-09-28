# 💤 LazyVim quick config

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## First install Lazyvim and its prerequiriste with mamba

<details>
<summary>Click to expand and copy code</summary>
  
```bash
mamba create -n tools -c conda-forge \
  nvim git ripgrep fd-find fzf lazygit tree-sitter-cli \
  nodejs gcc make unzip curl wget tar gzip python pynvim python-lsp-server
  
mkdir -p ~/.local/bin

# Link the binaries and verify each one
for bin in nvim git rg fd fzf lazygit tree-sitter node npm curl wget pylsp; do
  src="$CONDA_PREFIX/bin/$bin"
  if [ -x "$src" ]; then
    ln -sf "$src" ~/.local/bin/$bin
  else
    echo "MISSING: $bin"
  fi
done

# Make the PATH permanent and confirm every tool runs:
grep -q '.local/bin' ~/.bashrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
for bin in nvim git rg fd fzf lazygit tree-sitter node; do
  printf '%-12s %s\n' "$bin" "$($bin --version 2>&1 | head -1)"
done

```
</details>

## Then apply .config Editions

```
rm -rf ~/.config/nvim
git clone git@github.com:GeraultTr/lazyvim_kickstart.git ~/.config/nvim
```

Which adds the content of ~/.config/nvim/plugin/diagnostics.lua , theme.lua, outline.lua and claudecode.lua , compared to the vanilla lazyvim config

It is recommanded to use the Wezterm terminal for fonts and clipboard to work properly.

### (Recommended) Setup terminal to use and aliases for quick launch

```
alias gb='cd ~/Programs/Grass-BRIDGES_framework && mamba activate grass-bridges && nvim'
```
and type space qs when arriving to restore the session associated with the working directory pointed by the alias_


# Lazyvim keybindings

[keybindings](lazyvim_useful_keys.md)
