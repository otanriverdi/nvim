local function on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  require("lsp_signature").on_attach({ hint_enable = false }, bufnr)

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

      ["<leader>la"] = {
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
      "hrsh7th/cmp-nvim-lsp",
      {
        "folke/neodev.nvim",
        config = function()
          require("neodev").setup({})
        end,
      },
      { "ray-x/lsp_signature.nvim" },
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

      -- export on_attach & capabilities for custom lspconfigs

      M.capabilities = vim.lsp.protocol.make_client_capabilities()
      M.capabilities = require("cmp_nvim_lsp").default_capabilities(M.capabilities)

      -- Add the server here if you dont want to override settings
      -- otherwise you need to manually setup
      local servers = { "html", "cssls", "gopls", "lua_ls", "eslint" }

      for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup({
          on_attach = on_attach,
          capabilities = M.capabilities,
        })
      end

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
  {
    "simrat39/rust-tools.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
      "rcarriga/nvim-dap-ui",
    },
    ft = "rust",
    config = function()
      local extension_path = vim.env.HOME .. "/.local/share/nvim/mason/packages/codelldb/extension/"
      local codelldb_path = extension_path .. "adapter/codelldb"
      local liblldb_path = extension_path .. "lldb/lib/liblldb.dylib"

      local rust = require("rust-tools")

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      rust.setup({
        server = {
          on_attach = on_attach,
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
          settings = {
            ["rust-analyzer"] = {
              checkOnSave = {
                command = "clippy",
              },
            },
          },
        },
        dap = {
          adapter = require("rust-tools.dap").get_codelldb_adapter(codelldb_path, liblldb_path),
        },
      })
    end,
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "neovim/nvim-lspconfig",
    },
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    config = function()
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- We configure this here to have access to our custom on_attach and capabilities functions
      require("typescript").setup({
        server = {
          on_attach = on_attach,
          capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities),
          root_dir = require("lspconfig.util").root_pattern(".git"),
        },
      })
    end,
  },
}
