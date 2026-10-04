return {
  -- add gruvbox
  { "jakubkarlicek/molokai-nvim" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "molokai-nvim",
    },
  },
}
