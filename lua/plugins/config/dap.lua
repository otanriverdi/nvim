return {
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   cmd = { "DapToggleBreakpoint", "DapContinue", "DapUIOpen" },
  --   dependencies = { "mfussenegger/nvim-dap" },
  --   config = function()
  --     local dapui = require("dapui")
  --
  --     dapui.setup({
  --       icons = { expanded = "▾", collapsed = "▸" },
  --       mappings = {
  --         -- Use a table to apply multiple mappings
  --         expand = { "<CR>", "<2-LeftMouse>" },
  --         open = "o",
  --         remove = "d",
  --         edit = "e",
  --         repl = "r",
  --         toggle = "t",
  --       },
  --       -- Expand lines larger than the window
  --       -- Requires >= 0.7
  --       expand_lines = vim.fn.has("nvim-0.7"),
  --       -- Layouts define sections of the screen to place windows.
  --       -- The position can be 'left', 'right', 'top' or 'bottom'.
  --       -- The size specifies the height/width depending on position. It can be an Int
  --       -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  --       -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  --       -- Elements are the elements shown in the layout (in order).
  --       -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  --       layouts = {
  --         {
  --           elements = {
  --             -- Elements can be strings or table with id and size keys.
  --             { id = "scopes", size = 0.25 },
  --             "breakpoints",
  --             "stacks",
  --             "watches",
  --           },
  --           size = 40, -- 40 columns
  --           position = "right",
  --         },
  --         {
  --           elements = {
  --             "repl",
  --             "console",
  --           },
  --           size = 0, -- 25% of total lines
  --           position = "bottom",
  --         },
  --       },
  --       floating = {
  --         max_height = nil, -- These can be integers or a float between 0 and 1.
  --         max_width = nil, -- Floats will be treated as percentage of your screen.
  --         mappings = {
  --           close = { "q", "<Esc>" },
  --         },
  --       },
  --       windows = { indent = 1 },
  --       render = {
  --         max_type_length = nil, -- Can be integer or nil.
  --       },
  --     })
  --
  --     -- We know dap exists because we load dapui after it
  --     local dap = require("dap")
  --
  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapui.open(1)
  --     end
  --     dap.listeners.before.event_terminated["dapui_config"] = function()
  --       dapui.close()
  --     end
  --     dap.listeners.before.event_exited["dapui_config"] = function()
  --       dapui.close()
  --     end
  --
  --     vim.api.nvim_create_user_command("DapUIOpen", function()
  --       dapui.open()
  --     end, {})
  --
  --     vim.api.nvim_create_user_command("DapUIClose", function()
  --       dapui.close()
  --     end, {})
  --   end,
  -- },
  -- {
  --   "mfussenegger/nvim-dap",
  --   dependencies = {
  --     {
  --       "theHamsta/nvim-dap-virtual-text",
  --       config = function()
  --         local dvt = require("nvim-dap-virtual-text")
  --
  --         dvt.setup()
  --
  --         vim.g.dap_virtual_text = true
  --       end,
  --     },
  --     {
  --       "nvim-telescope/telescope-dap.nvim",
  --       dependencies = { "nvim-telescope/telescope.nvim" },
  --       config = function()
  --         local telescope = require("telescope")
  --
  --         telescope.load_extension("dap")
  --       end,
  --     },
  --   },
  --   config = function()
  --     local dap = require("dap")
  --     local sign = vim.fn.sign_define
  --
  --     -- for catpuccin
  --     sign("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
  --     sign("DapBreakpointCondition", { text = "●", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
  --     sign("DapLogPoint", { text = "◆", texthl = "DapLogPoint", linehl = "", numhl = "" })
  --
  --     dap.adapters.delve = {
  --       type = "server",
  --       port = "${port}",
  --       executable = {
  --         command = "dlv",
  --         args = { "dap", "-l", "127.0.0.1:${port}" },
  --       },
  --     }
  --
  --     -- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
  --     dap.configurations.go = {
  --       {
  --         type = "delve",
  --         name = "Debug",
  --         request = "launch",
  --         program = "${file}",
  --       },
  --       {
  --         type = "delve",
  --         name = "Debug test", -- configuration for debugging test files
  --         request = "launch",
  --         mode = "test",
  --         program = "${file}",
  --       },
  --       -- works with go.mod packages and sub packages
  --       {
  --         type = "delve",
  --         name = "Debug test (go.mod)",
  --         request = "launch",
  --         mode = "test",
  --         program = "./${relativeFileDirname}",
  --       },
  --     }
  --
  --     dap.adapters.node2 = {
  --       type = "executable",
  --       command = "node-debug2-adapter",
  --     }
  --
  --     dap.configurations.javascript = {
  --       {
  --         name = "Launch",
  --         type = "node2",
  --         request = "launch",
  --         program = "${file}",
  --         cwd = vim.fn.getcwd(),
  --         sourceMaps = true,
  --         protocol = "inspector",
  --         console = "integratedTerminal",
  --       },
  --       {
  --         -- For this to work you need to make sure the node process is started with the `--inspect` flag.
  --         name = "Attach to process",
  --         type = "node2",
  --         request = "attach",
  --         processId = require("dap.utils").pick_process,
  --       },
  --     }
  --
  --     dap.configurations.typescript = {
  --       {
  --         name = "ts-node (Node2 with ts-node)",
  --         type = "node2",
  --         request = "launch",
  --         cwd = vim.loop.cwd(),
  --         runtimeArgs = { "-r", "ts-node/register" },
  --         runtimeExecutable = "node",
  --         args = { "--inspect", "${file}" },
  --         sourceMaps = true,
  --         skipFiles = { "<node_internals>/**", "node_modules/**" },
  --       },
  --       {
  --         name = "Jest (Node2 with ts-node)",
  --         type = "node2",
  --         request = "launch",
  --         cwd = vim.loop.cwd(),
  --         runtimeArgs = { "--inspect-brk", "${workspaceFolder}/node_modules/.bin/jest" },
  --         runtimeExecutable = "node",
  --         args = { "${file}", "--runInBand", "--coverage", "false" },
  --         sourceMaps = true,
  --         port = 9229,
  --         skipFiles = { "<node_internals>/**", "node_modules/**" },
  --       },
  --       {
  --         -- For this to work you need to make sure the node process is started with the `--inspect` flag.
  --         name = "Attach to process",
  --         type = "node2",
  --         request = "attach",
  --         processId = require("dap.utils").pick_process,
  --         port = 9001,
  --       },
  --     }
  --   end,
  --   init = function()
  --     local mappings = {
  --       n = {
  --         ["<leader>dc"] = { "<cmd>DapContinue<CR>", "dap continue" },
  --         ["<leader>do"] = { "<cmd>lua require('dap').step_over()<CR>", "dap step over" },
  --         ["<leader>di"] = { "<cmd>lua require('dap').step_into()<CR>", "dap step into" },
  --         ["<leader>de"] = { "<cmd>lua require('dap').step_out()<CR>", "dap step out" },
  --         ["<leader>db"] = { "<cmd>DapToggleBreakpoint<CR>", "dap toggle breakpoint" },
  --       },
  --     }
  --     require("core.utils").load_mappings(mappings)
  --   end,
  -- },
}
