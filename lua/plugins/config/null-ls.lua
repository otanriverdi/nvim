return {
  {
    "jose-elias-alvarez/null-ls.nvim",
    dependencies = { "nvim-lspconfig" },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local null_ls = require("null-ls")

      local b = null_ls.builtins

      local sources = {
        -- JS/TS
        b.formatting.prettierd,
        b.diagnostics.eslint_d,
        b.code_actions.eslint_d,
        require("typescript.extensions.null-ls.code-actions"),

        -- Lua
        b.formatting.stylua,

        -- Go
        b.formatting.gofumpt,
        b.diagnostics.golangci_lint,

        -- Rust
        b.formatting.rustfmt,
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

      -- To restart eslint
      vim.api.nvim_create_user_command("EslintRestart", function()
        vim.fn.system("ps ax | grep eslint_d | grep -v grep | awk '{print $1}' | xargs kill")
        vim.cmd("e")
      end, {})
    end,
  },
}
