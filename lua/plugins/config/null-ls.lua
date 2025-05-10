return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lspconfig", "nvim-lua/plenary.nvim" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")

      local b = null_ls.builtins

      local sources = {
        -- JS/TS
        b.formatting.prettierd,

        -- Lua
        b.formatting.stylua,

        -- Go
        b.formatting.gofumpt,
        b.diagnostics.golangci_lint,

        -- Python
        b.formatting.black,

        b.formatting.clang_format,
      }

      null_ls.setup({
        sources = sources,
        root_dir = require("null-ls.utils").root_pattern(".git"),

        on_attach = function(client, bufnr)
          if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({
                  bufnr = bufnr,
                  async = false,
                  filter = function(c)
                    return c.name == "null-ls"
                  end,
                })
              end,
            })
          end
        end,
      })
    end,
  },
}
