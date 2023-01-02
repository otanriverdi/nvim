local present, lualine = pcall(require, "lualine")

if not present then
  return
end

lualine.setup({
  theme = "tokyonight",
  options = {
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", { "diagnostics", sources = { "nvim_workspace_diagnostic" }, sections = { "error" } } },
    lualine_c = { "filename", "diagnostics" },
    lualine_x = {},
    lualine_y = { "encoding" },
    lualine_z = { "progress" },
  },
})
