return {
  "max397574/better-escape.nvim",
  event = "InsertEnter",
  config = function()
    local b = require("better_escape")

    local options = {
      mapping = { "jk" },
    }

    b.setup(options)
  end,
}
