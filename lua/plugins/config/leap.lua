return {
  "ggandor/leap.nvim",
  enabled = false,
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("leap").add_default_mappings()
  end,
}
