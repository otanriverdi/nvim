return {
  "ggandor/leap.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("leap").add_default_mappings()
  end,
}
