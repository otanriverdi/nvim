return {
  "catppuccin/nvim",
  name = "catppuccin",
  enabled = false,
  lazy = false,
  priority = 1000,
  config = function()
    local catpuccin = require("catppuccin")

    catpuccin.setup({
      flavour = "macchiato",
      term_colors = true,
      integrations = {
        cmp = true,
        gitsigns = true,
        harpoon = true,
        mason = true,
        telescope = true,
        treesitter = true,
        dap = {
          enabled = true,
          enable_ui = true,
        },
        indent_blankline = {
          enabled = true,
          colored_indent_levels = false,
        },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
        },
      },
    })

    vim.cmd([[colorscheme catppuccin]])
  end,
}
