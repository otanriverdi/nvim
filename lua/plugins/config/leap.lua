return {
  "ggandor/leap.nvim",
  enable = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("leap").add_default_mappings()
  end,
}
