local utils = require("core.utils")

local autocmd = vim.api.nvim_create_autocmd

local function lazyload()
  autocmd({ "BufReadPre" }, {
    group = vim.api.nvim_create_augroup("GitSignsLazyLoad", { clear = true }),
    callback = function()
      vim.fn.system("git rev-parse " .. vim.fn.expand("%:p:h"))
      if vim.v.shell_error == 0 then
        vim.api.nvim_del_augroup_by_name("GitSignsLazyLoad")
        vim.schedule(function()
          require("lazy").load({ plugins = { "gitsigns.nvim" } })
        end)
      end
    end,
  })
end

return {
  "lewis6991/gitsigns.nvim",
  init = function()
    lazyload()
  end,
  config = function()
    local g = require("gitsigns")

    local options = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
      },
      on_attach = function(bufnr)
        local mappings = {
          n = {
            -- Navigation through hunks
            ["]c"] = {
              function()
                if vim.wo.diff then
                  return "]c"
                end
                vim.schedule(function()
                  require("gitsigns").next_hunk()
                end)
                return "<Ignore>"
              end,
              "Jump to next hunk",
              opts = { expr = true },
            },

            ["[c"] = {
              function()
                if vim.wo.diff then
                  return "[c"
                end
                vim.schedule(function()
                  require("gitsigns").prev_hunk()
                end)
                return "<Ignore>"
              end,
              "Jump to prev hunk",
              opts = { expr = true },
            },

            -- Actions
            ["<leader>rh"] = {
              function()
                require("gitsigns").reset_hunk()
              end,
              "Reset hunk",
            },

            ["<leader>ph"] = {
              function()
                require("gitsigns").preview_hunk()
              end,
              "Preview hunk",
            },

            ["<leader>gb"] = {
              function()
                package.loaded.gitsigns.blame_line()
              end,
              "Blame line",
            },

            ["<leader>td"] = {
              function()
                require("gitsigns").toggle_deleted()
              end,
              "Toggle deleted",
            },
          },
        }

        utils.load_mappings(mappings, { buffer = bufnr })
      end,
    }

    g.setup(options)
  end,
}
