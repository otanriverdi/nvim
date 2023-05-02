-- HAS SOME SETUP IN CMP
return {
  "github/copilot.vim",
  event = { "InsertEnter" },
  init = function()
    vim.g.copilot_no_tab_map = true

    local mappings = {
      i = {
        ["<Plug>(vimrc:copilot-dummy-map)"] = {
          'copilot#Accept("")',
          "Copilot dummy accept",
          opts = { expr = true, silent = true },
        },
      },
    }

    require("core.utils").load_mappings(mappings)
  end,
}
