local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

local b = null_ls.builtins

local sources = {
  -- JS/TS
  b.formatting.prettierd,
  b.diagnostics.eslint_d,
  b.code_actions.eslint_d,

  -- Lua
  b.formatting.stylua,

  -- Go
  b.formatting.gofumpt,
  b.diagnostics.golangci_lint,

  -- Rust
  b.formatting.rustfmt,
}

null_ls.setup {
  sources = sources,

  on_attach = function(client)
    if client.server_capabilities.documentFormattingProvider then
      vim.cmd "autocmd BufWritePre <buffer> lua vim.lsp.buf.format { async = false }"
    end
  end,
}
