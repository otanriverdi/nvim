return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    local tn = require("tokyonight")

    tn.setup({
      transparent = true,
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
