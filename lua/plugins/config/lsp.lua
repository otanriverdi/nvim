local function on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  local mappings = {
    x = {
      ["<leader>la"] = {
        function()
          vim.lsp.buf.code_action()
        end,
        "lsp code_action",
        opts = { buffer = bufnr },
      },
    },
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

      ["<leader>lt"] = {
        function()
          vim.lsp.buf.type_definition()
        end,
        "lsp definition type",
        opts = { buffer = bufnr },
      },

      ["<leader>lr"] = {
        function()
          vim.lsp.buf.rename()
        end,
        "lsp rename",
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

      ["<leader>lf"] = {
        function()
          vim.lsp.buf.format({ async = true })
        end,
        "lsp formatting",
        opts = { buffer = bufnr },
      },
    },
  }

  local utils = require("core.utils")

  utils.load_mappings(mappings)
end

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "saghen/blink.cmp",
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup({
            library = { plugins = { "nvim-dap-ui" }, types = true },
          })
        end,
      },
      {
        "j-hui/fidget.nvim",
        tag = "legacy",
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

      lspSymbol("Error", "E")
      lspSymbol("Info", "I")
      lspSymbol("Hint", "H")
      lspSymbol("Warn", "W")

      vim.diagnostic.config({
        virtual_text = {
          severity = vim.diagnostic.severity.ERROR,
        },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
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

      -- export on_attach & capabilities for custom lspconfigs

      M.capabilities = vim.lsp.protocol.make_client_capabilities()
      M.capabilities = require("blink.cmp").get_lsp_capabilities(M.capabilities)

      -- Add the server here if you dont want to override settings
      -- otherwise you need to manually setup
      local servers = { "html", "cssls", "gopls", "lua_ls", "eslint", "clangd", "zls" }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = M.capabilities,
        })
      end

      lspconfig.ts_ls.setup({
        on_attach = on_attach,
        capabilities = M.capabilities,
        root_dir = lspconfig.util.root_pattern(".git"),
      })

      lspconfig.gopls.setup({
        on_attach = on_attach,
        capabilities = M.capabilities,
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        root_dir = lspconfig.util.root_pattern("go.mod", ".git", "go.work"),
        settings = {
          gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = {
              unusedparams = true,
            },
          },
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
        PATH = "skip",

        ui = {
          icons = {
            package_pending = "P ",
            package_installed = "I ",
            package_uninstalled = "U ",
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
