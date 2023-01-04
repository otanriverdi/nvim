return {
  "nvim-lualine/lualine.nvim",
  lazy = false,
  config = function()
    local l = require("lualine")

    l.setup({
      theme = "tokyonight",
      options = {
        section_separators = { left = "", right = "" },
        component_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = {
          "branch",
          "diff",
          { "diagnostics", sources = { "nvim_workspace_diagnostic" }, sections = { "error" } },
        },
        lualine_c = { "filename", "diagnostics" },
        lualine_x = {},
        lualine_y = { "encoding" },
        lualine_z = { "progress" },
      },
    })
  end,
}
