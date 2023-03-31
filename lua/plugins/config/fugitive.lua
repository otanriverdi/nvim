return {
  "tpope/vim-fugitive",
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
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}
