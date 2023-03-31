return {
  "catppuccin/nvim",
  name = "catppuccin",
  -- enabled = false,
  lazy = false,
  priority = 1000,
  config = function()
    local catpuccin = require("catppuccin")

    catpuccin.setup({
      flavour = "macchiato", -- latte, frappe, macchiato, mocha
      transparent_background = false,
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = false,
        telescope = true,
        notify = false,
        mini = false,
        harpoon = true,
        -- leap = true,
        treesitter_context = true,
      },
      custom_highlights = function(c)
        return { CursorLineNr = {
          fg = c.blue,
        }, LineNr = {
          fg = c.blue,
        } }
      end,
    })

    vim.cmd([[colorscheme catppuccin]])
  end,
}
