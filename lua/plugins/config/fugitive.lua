return {
  "tpope/vim-fugitive",
  enabled = false,
  lazy = false,
  init = function()
    local mappings = {
      n = {
        ["gu"] = {
          "<cmd>diffget //2<CR>",
          "select left diff",
        },
        ["gh"] = {
          "<cmd>diffget //3<CR>",
          "select right dif",
        },
        ["<leader>gs"] = {
          "<cmd>vertical G<CR>",
          "open git status",
        },
      },
    }

    vim.g.fugitive_pty = 0

    require("core.utils").load_mappings(mappings)
  end,
}
