return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        pylsp = {
          mason = false, -- use pylsp from ~/.local/bin instead of Mason's
          settings = {
            pylsp = {
              plugins = {
                -- ruff (also enabled by the extra) already handles linting
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                mccabe = { enabled = false },
              },
            },
          },
        },
      },
    },
  },
}
