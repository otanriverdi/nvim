return {
  "mbbill/undotree",
  event = { "BufReadPre", "BufNewFile" },
  init = function()
    local keymaps = {
      n = {
        ["<leader>u"] = { "<cmd>UndotreeToggle<CR>", "Open undotree" },
      },
    }

    require("core.utils").load_mappings(keymaps)
  end,
}
