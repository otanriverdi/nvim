return {
  "NeogitOrg/neogit",
  lazy = false,
  dependencies = {
    "nvim-lua/plenary.nvim",
    "sindrets/diffview.nvim",
    "nvim-telescope/telescope.nvim",
  },
  config = function()
    local mappings = {
      n = {
        ["<leader>gs"] = {
          "<cmd>Neogit kind=auto<CR>",
          "open git status",
        },
        ["<leader>gh"] = {
          "<cmd>DiffviewFileHistory %<CR>",
          "open git file history",
        },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}
