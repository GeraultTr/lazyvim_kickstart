return {
  -- Prefer ~/.local/bin tools over Mason's downloads
  { "mason-org/mason.nvim", opts = { PATH = "append" } },
  -- Avoid the prebuilt Rust matcher if it fails on this glibc
  { "saghen/blink.cmp", opts = { fuzzy = { implementation = "prefer_rust_with_warning" } } },
}
