return {
  {
    "rcarriga/nvim-dap-ui",
    cmd = { "DapUIOpen", "DapContinue", "DapToggleBreakpoint", "DapNodeSetPort" },
    dependencies = {
      "mxsdev/nvim-dap-vscode-js",
    },
    config = function()
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7"),
        -- Layouts define sections of the screen to place windows.
        -- The position can be 'left', 'right', 'top' or 'bottom'.
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "right",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0, -- 25% of total lines
            position = "bottom",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
        },
      })

      -- We know dap exists because we load dapui after it
      local dap = require("dap")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open(1)
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      vim.api.nvim_create_user_command("DapUIOpen", function()
        dapui.open()
      end, {})

      vim.api.nvim_create_user_command("DapUIClose", function()
        dapui.close()
      end, {})
    end,
  },
  {
    "mxsdev/nvim-dap-vscode-js",
    requires = { "mfussenegger/nvim-dap" },
    config = function()
      require("dap-vscode-js").setup({
        -- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
        -- debugger_path = "(runtimedir)/site/pack/packer/opt/vscode-js-debug", -- Path to vscode-js-debug installation.
        debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
        adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
        -- log_file_path = "(stdpath cache)/dap_vscode_js.log" -- Path for file logging
        -- log_file_level = false -- Logging level for output to file. Set to false to disable file logging.
        -- log_console_level = vim.log.levels.ERROR -- Logging level for output to console. Set to false to disable console output.
      })

      for _, language in ipairs({ "typescript", "javascript" }) do
        require("dap").configurations[language] = {
          {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
          },
          {
            type = "pwa-node",
            request = "attach",
            name = "Attach (Default)",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
          },
        }
      end

      vim.api.nvim_create_user_command("DapNodeSetPort", function(opts)
        for _, language in ipairs({ "typescript", "javascript" }) do
          local configs = require("dap").configurations[language]

          require("dap").configurations[language][#configs + 1] = {
            type = "pwa-node",
            request = "attach",
            name = "Attach (" .. opts.args .. ")",
            processId = require("dap.utils").pick_process,
            cwd = "${workspaceFolder}",
            port = opts.args,
          }
        end
      end, { nargs = 1 })
    end,
  },
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      {
        "theHamsta/nvim-dap-virtual-text",
        config = function()
          local dvt = require("nvim-dap-virtual-text")

          dvt.setup()

          vim.g.dap_virtual_text = true
        end,
      },
      {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        config = function()
          local telescope = require("telescope")

          telescope.load_extension("dap")
        end,
      },
    },
    config = function()
      local dap = require("dap")
      local sign = vim.fn.sign_define

      -- for catpuccin
      sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
      sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
      sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })

      dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
          command = "dlv",
          args = { "dap", "-l", "127.0.0.1:${port}" },
        },
      }

      -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
      dap.configurations.go = {
        {
          type = "delve",
          name = "Debug",
          request = "launch",
          program = "${file}",
        },
        {
          type = "delve",
          name = "Debug test", -- configuration for debugging test files
          request = "launch",
          mode = "test",
          program = "${file}",
        },
        -- works with go.mod packages and sub packages
        {
          type = "delve",
          name = "Debug test (go.mod)",
          request = "launch",
          mode = "test",
          program = "./${relativeFileDirname}",
        },
      }

      require("dap.ext.vscode").load_launchjs(
        nil,
        { node = { "javascript", "javascriptreact", "typescriptreact", "typescript" } }
      )
    end,
    init = function()
      local mappings = {
        n = {
          ["<leader>dc"] = { "<cmd>DapContinue<CR>", "dap continue" },
          ["<leader>dt"] = { "<cmd>DapTerminate<CR>", "dap terminate" },
          ["<leader>do"] = { "<cmd>lua require('dap').step_over()<CR>", "dap step over" },
          ["<leader>di"] = { "<cmd>lua require('dap').step_into()<CR>", "dap step into" },
          ["<leader>de"] = { "<cmd>lua require('dap').step_out()<CR>", "dap step out" },
          ["<leader>db"] = { "<cmd>DapToggleBreakpoint<CR>", "dap toggle breakpoint" },
        },
      }
      require("core.utils").load_mappings(mappings)
    end,
  },
}
