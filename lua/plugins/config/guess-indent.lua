return {
  "nmac427/guess-indent.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local g = require("guess-indent")

    local options = {
      filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
        "netrw",
        "tutor",
        "alpha",
        "packer",
        "lspinfo",
        "TelescopePrompt",
        "TelescopeResults",
        "mason",
      },
      buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
        "help",
        "nofile",
        "terminal",
        "prompt",
      },
    }

    g.setup(options)
  end,
}
