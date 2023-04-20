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
        require("typescript.extensions.null-ls.code-actions"),

        -- Lua
        b.formatting.stylua,

        -- Go
        b.formatting.gofumpt,
        b.diagnostics.golangci_lint,

        -- Rust
        b.formatting.rustfmt,

        -- Python
        b.diagnostics.pylint,
        b.formatting.black,
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

      null_ls.builtins.formatting.rustfmt.with({
        extra_args = function(params)
          local Path = require("plenary.path")
          local cargo_toml = Path:new(params.root .. "/" .. "Cargo.toml")

          if cargo_toml:exists() and cargo_toml:is_file() then
            for _, line in ipairs(cargo_toml:readlines()) do
              local edition = line:match([[^edition%s*=%s*%"(%d+)%"]])
              if edition then
                return { "--edition=" .. edition }
              end
            end
          end
          -- default edition when we don't find `Cargo.toml` or the `edition` in it.
          return { "--edition=2021" }
        end,
      })
    end,
  },
}
