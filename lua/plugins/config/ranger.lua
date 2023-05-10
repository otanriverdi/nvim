return {
  "kelly-lin/ranger.nvim",
  lazy = false,
  config = function()
    require("ranger-nvim").setup({
      replace_netrw = true,
    })
  end,
  init = function()
    local mappings = {
      n = {
        ["<leader>e"] = { ":lua require('ranger-nvim').open(true)<CR>", "open directory browser" },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}
