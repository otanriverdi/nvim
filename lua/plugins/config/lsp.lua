return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "jose-elias-alvarez/typescript.nvim",
      { "simrat39/rust-tools.nvim", dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" } },
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup({})
        end,
      },
      {
        "j-hui/fidget.nvim",
        config = function()
          require("fidget").setup({
            window = {
              blend = 0,
            },
          })
        end,
      },
    },
    config = function()
      local lspconfig = require("lspconfig")

      local function lspSymbol(name, icon)
        local hl = "DiagnosticSign" .. name
        vim.fn.sign_define(hl, { text = icon, numhl = hl, texthl = hl })
      end

      lspSymbol("Error", "")
      lspSymbol("Info", "")
      lspSymbol("Hint", "")
      lspSymbol("Warn", "")

      vim.diagnostic.config({
        virtual_text = {
          prefix = "",
        },
        signs = true,
        underline = true,
        update_in_insert = false,
      })

      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "single",
      })

      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "single",
        focusable = false,
        relative = "cursor",
      })

      -- suppress error messages from lang servers
      vim.notify = function(msg, log_level)
        if msg:match("exit code") then
          return
        end
        if log_level == vim.log.levels.ERROR then
          vim.api.nvim_err_writeln(msg)
        else
          vim.api.nvim_echo({ { msg } }, true, {})
        end
      end

      -- Borders for LspInfo winodw
      local win = require("lspconfig.ui.windows")
      local _default_opts = win.default_opts

      win.default_opts = function(options)
        local opts = _default_opts(options)
        opts.border = "single"
        return opts
      end

      local M = {}
      local utils = require("core.utils")

      -- export on_attach & capabilities for custom lspconfigs

      M.on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        local mappings = {
          n = {
            ["gD"] = {
              function()
                vim.lsp.buf.declaration()
              end,
              "lsp declaration",
              opts = { buffer = bufnr },
            },

            ["K"] = {
              function()
                vim.lsp.buf.hover()
              end,
              "lsp hover",
              opts = { buffer = bufnr },
            },

            ["<leader>ls"] = {
              function()
                vim.lsp.buf.signature_help()
              end,
              "lsp signature_help",
              opts = { buffer = bufnr },
            },

            ["<leader>D"] = {
              function()
                vim.lsp.buf.type_definition()
              end,
              "lsp definition type",
              opts = { buffer = bufnr },
            },

            ["<leader>ra"] = {
              function()
                vim.lsp.buf.rename()
              end,
              "lsp rename",
              opts = { buffer = bufnr },
            },

            ["<leader>ca"] = {
              function()
                vim.lsp.buf.code_action()
              end,
              "lsp code_action",
              opts = { buffer = bufnr },
            },

            ["<leader>f"] = {
              function()
                vim.diagnostic.open_float()
              end,
              "floating diagnostic",
              opts = { buffer = bufnr },
            },

            ["[d"] = {
              function()
                vim.diagnostic.goto_prev()
              end,
              "goto prev",
              opts = { buffer = bufnr },
            },

            ["]d"] = {
              function()
                vim.diagnostic.goto_next()
              end,
              "goto_next",
              opts = { buffer = bufnr },
            },

            ["<leader>fm"] = {
              function()
                vim.lsp.buf.format({ async = true })
              end,
              "lsp formatting",
              opts = { buffer = bufnr },
            },

            ["<leader>wa"] = {
              function()
                vim.lsp.buf.add_workspace_folder()
              end,
              "add workspace folder",
              opts = { buffer = bufnr },
            },

            ["<leader>wr"] = {
              function()
                vim.lsp.buf.remove_workspace_folder()
              end,
              "remove workspace folder",
              opts = { buffer = bufnr },
            },

            ["<leader>wl"] = {
              function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end,
              "list workspace folders",
              opts = { buffer = bufnr },
            },
          },
        }

        utils.load_mappings(mappings)
      end

      M.capabilities = vim.lsp.protocol.make_client_capabilities()
      M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

      -- Add the server here if you dont want to override settings
      -- otherwise you need to manually setup
      local servers = { "html", "cssls", "gopls", "sumneko_lua" }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = M.on_attach,
          capabilities = M.capabilities,
        })
      end

      -- We configure this here to have access to our custom on_attach and capabilities functions
      require("typescript").setup({
        server = {
          on_attach = M.on_attach,
          capabilities = M.capabilities,
          root_dir = require("lspconfig.util").root_pattern(".git"),
        },
      })

      local rust = require("rust-tools")

      rust.setup({
        server = {
          on_attach = M.on_attach,
          capabilities = M.capabilities,
        },
        inlay_hints = {
          auto = false,
        },
      })

      return M
    end,
  },
  {

    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    config = function()
      local mason = require("mason")

      local options = {
        ensure_installed = {
          "lua-language-server",
          "stylua",
          "css-lsp",
          "html-lsp",
          "typescript-language-server",
          "gopls",
          "rust-analyzer",
          "eslint_d",
          "prettierd",
        }, -- not an option from mason.nvim

        PATH = "skip",

        ui = {
          icons = {
            package_pending = " ",
            package_installed = " ",
            package_uninstalled = " ﮊ",
          },

          keymaps = {
            toggle_server_expand = "<CR>",
            install_server = "i",
            update_server = "u",
            check_server_version = "c",
            update_all_servers = "U",
            check_outdated_servers = "C",
            uninstall_server = "X",
            cancel_installation = "<C-c>",
          },
        },

        max_concurrent_installers = 10,
      }

      vim.api.nvim_create_user_command("MasonInstallAll", function()
        vim.cmd("MasonInstall " .. table.concat(options.ensure_installed, " "))
      end, {})

      mason.setup(options)
    end,
  },
}
