return {
  "mfussenegger/nvim-dap",
  lazy = true,
  cmd = { "DapContinue", "DapToggleBreakpoint", "DapNodeSetPort" },
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "mxsdev/nvim-dap-vscode-js",
    {
      "nvim-telescope/telescope-dap.nvim",
      dependencies = { "nvim-telescope/telescope.nvim" },
      config = function()
        local telescope = require("telescope")

        telescope.load_extension("dap")
      end,
    },
    {
      "microsoft/vscode-js-debug",
      tag = "v1.74.1",
      build = "npm install --legacy-peer-deps && npx gulp vsDebugServerBundle && mv dist out",
    },
  },
  init = function()
    local mappings = {
      n = {
        ["<leader>dc"] = { "<cmd>DapContinue<CR>", "dap continue" },
        ["<leader>dt"] = { "<cmd>DapTerminate<CR>", "dap terminate" },
        ["<leader>dk"] = { "<cmd>lua require('dap.ui.widgets').hover()<CR>", "dap hover" },
        ["<leader>do"] = { "<cmd>lua require('dap').step_over()<CR>", "dap step over" },
        ["<leader>di"] = { "<cmd>lua require('dap').step_into()<CR>", "dap step into" },
        ["<leader>de"] = { "<cmd>lua require('dap').step_out()<CR>", "dap step out" },
        ["<leader>db"] = { "<cmd>DapToggleBreakpoint<CR>", "dap toggle breakpoint" },
      },
    }
    require("core.utils").load_mappings(mappings)
  end,
  config = function()
    local dap = require("dap")

    require("dap-vscode-js").setup({
      debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
      adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
    })

    -- JS/TS
    for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
      dap.configurations[language] = {
        {
          type = "pwa-node",
          request = "attach",
          processId = require("dap.utils").pick_process,
          name = "Attach debugger to existing `node --inspect` process",
          sourceMaps = true,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
          cwd = "${workspaceFolder}/src",
          skipFiles = { "${workspaceFolder}/node_modules/**/*.js" },
        },
        {
          type = "pwa-chrome",
          name = "Launch Chrome to debug client",
          request = "launch",
          url = "http://localhost:5173",
          sourceMaps = true,
          protocol = "inspector",
          port = 9222,
          webRoot = "${workspaceFolder}/src",
          skipFiles = { "**/node_modules/**/*", "**/@vite/*", "**/src/client/*", "**/src/*" },
        },
        language == "javascript" and {
          type = "pwa-node",
          request = "launch",
          name = "Launch file in new node process",
          program = "${file}",
          cwd = "${workspaceFolder}",
        } or nil,
      }
    end

    -- We use this to change the port in case the default one is already in use
    vim.api.nvim_create_user_command("DapNodeSetPort", function(opts)
      for _, language in ipairs({ "typescript", "javascript", "svelte" }) do
        local configs = require("dap").configurations[language]

        dap.configurations[language][#configs + 1] = {
          type = "pwa-node",
          request = "attach",
          name = "Attach (" .. opts.args .. ")",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
          port = opts.args,
          resolveSourceMapLocations = {
            "${workspaceFolder}/**",
            "!**/node_modules/**",
          },
        }
      end
    end, { nargs = 1 })
    -- END JS/TS

    -- Cense
    local configs = require("dap").configurations.typescript
    dap.configurations.typescript[#configs + 1] = {
      name = "Debug Cense Server",
      port = 9230,
      type = "pwa-node",
      request = "attach",
      skipFiles = {
        "${workspaceFolder}/node_modules/**/*.js",
        "<node_internals>/**",
      },
      sourceMapPathOverrides = {
        ["webpack://?:*/*"] = "${workspaceFolder}/apps/server/*",
      },
    }

    -- GOLANG
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
    -- END GOLANG

    require("nvim-dap-virtual-text").setup()

    require("dapui").setup()
    local dapui = require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({ reset = true })
    end
    dap.listeners.before.event_terminated["dapui_config"] = dapui.close
    dap.listeners.before.event_exited["dapui_config"] = dapui.close
  end,
}
