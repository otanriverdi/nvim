return {
  "stevearc/oil.nvim",
  enabled = false,
  lazy = false,
  config = function()
    require("oil").setup({
      columns = {
        "icon",
        "permissions",
        "size",
      },
      keymaps = {
        ["<leader>e"] = "actions.close",
        ["q"] = "actions.close",
      },
    })
  end,
  init = function()
    local mappings = {
      n = {
        ["<leader>e"] = { ":lua require('oil').open()<CR>", "open directory browser" },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}
