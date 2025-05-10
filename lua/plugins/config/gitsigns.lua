local utils = require("core.utils")

return {
  "lewis6991/gitsigns.nvim",
  lazy = false,
  config = function()
    local g = require("gitsigns")

    local options = {
      signs = {
        add = { text = "│" },
        change = { text = "│" },
        delete = { text = "D" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
        untracked = { text = "│" },
      },
      on_attach = function(bufnr)
        local mappings = {
          n = {
            -- Navigation through hunks
            ["]h"] = {
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

            ["[h"] = {
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
            ["<leader>gr"] = {
              function()
                require("gitsigns").reset_hunk()
              end,
              "Reset hunk",
            },

            ["<leader>gp"] = {
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

            ["<leader>gd"] = {
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
