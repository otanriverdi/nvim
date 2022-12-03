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
  require "plugins.configs.dap.go"
  require "plugins.configs.dap.node"
end

M.dapui = function()
  local present, dapui = pcall(require, "dapui")

  if not present then
    return
  end

  dapui.setup()

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
end

return M
