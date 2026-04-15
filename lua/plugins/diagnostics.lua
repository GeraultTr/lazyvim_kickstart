-- Only show ERROR diagnostics in the buffer (no WARN/INFO/HINT)
return {
  "neovim/nvim-lspconfig",
  opts = {
    diagnostics = {
      virtual_text = {
        severity = vim.diagnostic.severity.ERROR,
      },
      underline = {
        severity = vim.diagnostic.severity.ERROR,
      },
      signs = {
        severity = vim.diagnostic.severity.ERROR,
      },
    },
  },
}
