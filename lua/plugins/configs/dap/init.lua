local M = {}

M.dap_virtual_text = function()
  local present, dap_virtual_text = pcall(require, "nvim-dap-virtual-text")

  if not present then
    return
  end

  dap_virtual_text.setup()

  vim.g.dap_virtual_text = true
end

M.dap = function()
  vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticSignError", linehl = "", numhl = "" })
  vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticSignWarn", linehl = "", numhl = "" })
  vim.fn.sign_define("DapStopped", { text = "", texthl = "GitSignsDelete", linehl = "GitSignsDeleteLn", numhl = "" })

  require "plugins.configs.dap.go"
  require "plugins.configs.dap.node"
end

M.dapui = function()
  local present, dapui = pcall(require, "dapui")

  if not present then
    return
  end

  dapui.setup {
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
    expand_lines = vim.fn.has "nvim-0.7",
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
  }

  -- We know dap exists because we load dapui after it
  local dap = require "dap"

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
end

return M
