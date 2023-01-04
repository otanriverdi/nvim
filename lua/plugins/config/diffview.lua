return {
  "sindrets/diffview.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = { "DiffviewOpen", "DiffviewFileHistory" },
  config = function()
    local d = require("diffview")

    local options = {
      file_panel = {
        win_config = {
          position = "right",
          width = 35,
        },
      },
    }

    d.setup(options)
  end,
  init = function()
    local mappings = {
      n = {
        ["<leader>gd"] = { "<cmd> DiffviewOpen <CR>", "open diffview" },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}
