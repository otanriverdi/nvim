return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  dependencies = "nvim-cmp",
  config = function()
    local a = require("nvim-autopairs")

    local options = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim", "alpha" },
    }

    a.setup(options)

    local c = require("cmp")
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    c.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
