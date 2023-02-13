return {
  "folke/tokyonight.nvim",
  enabled = false,
  lazy = false,
  priority = 1000,
  config = function()
    local tn = require("tokyonight")

    tn.setup({
      terminal_colors = true,
      style = "storm",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      on_highlights = function(hl, c)
        hl.CursorLineNr = {
          fg = c.blue,
        }
        hl.LineNr = {
          fg = c.blue,
        }
      end,
    })

    vim.cmd([[colorscheme tokyonight]])
  end,
}
